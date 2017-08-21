from Bio import SeqIO
import re ,sys
import numpy as np

protein = sys.argv[1]

fasta_file = sys.stdin

rawfile = protein + '.fa'
raw_file = open(rawfile,'r')

sequences = []
names = []
for line in fasta_file:
    organisms = re.match('>[a-z]+',line)
    if organisms:
        organism = line.strip()
        names.append(organism)
    else:
        sequences.append(line.strip())

counts = []
for i in range(len(sequences)):
    sequence = sequences[i]
    gapcount = sequence.count('-')
    counts.append(gapcount)

quartile = np.percentile(counts,[25,50,75],interpolation='nearest')
iqr = (quartile[2]-quartile[0])
lower = quartile[0]-(1.5*iqr)
upper = quartile[2]+(1.5*iqr)

fin_name = []
fin_seq = []
dump_name = []
dump_seq = []

for j in range(len(sequences)):
    sequence = sequences[j]
    gapcount = sequence.count('-')
    if gapcount < upper and gapcount > lower:
        fin_name.append(names[j])
        fin_seq.append(sequence)
    else:
        dump_name.append(names[j])
        dump_seq.append(sequence)

org = []
fasta = []
for line in raw_file:
    organism = re.match('>[a-z]+',line)
    if organism:
        species = line.strip()
        org.append(species)
    else:
        fasta.append(line.strip())

for k in range(len(org)):
    if org[k] in fin_name:
        print(org[k] + '\n' + fasta[k])

outfile = protein + '_dump.txt'
file = open(outfile, "w")
for k in range(len(dump_name)):
    file.write(dump_name[k] + '\n' + dump_seq[k] + '\n')
file.close()
