from __future__ import division
from Bio import SeqIO
import re
import sys

infile = sys.argv[1]
outfile = sys.argv[2]

fasta_sequences = SeqIO.parse(open(infile),'fasta')
sequences = []
names = []
for fasta in fasta_sequences:
    sequences.append(str(fasta.seq))
    names.append(fasta.id)

gap_pos = []
fin_seq = []
for i in range(len(sequences)):
    if names[i] =='homo_sapiens':
        sequence = sequences[i]
        for m in re.finditer("([-]+)",sequence):
            gap_pos.append(m.start())
            gap_pos.append(m.end())
for j in range(len(sequences)):
    sequence=sequences[j][:-3]
    delete=0
    for idx in range(0,len(gap_pos),2):
        if idx == 0:
            start = gap_pos[idx]
            end = gap_pos[idx+1]
        elif idx != 0:
            delete += gap_pos[idx-1] - gap_pos[idx-2]
            start = gap_pos[idx] - delete
            end = gap_pos[idx+1] - delete
        new_seq = sequence[0:start] + sequence[end:]
        sequence = new_seq
    fin_seq.append(sequence)

file = open(outfile, "w")
for i in range(len(fin_seq)):
    file.write(">" + names[i] + "\n" +fin_seq[i] + "\n")

file.close()
