from __future__ import division
from Bio import SeqIO
import re
import sys

organisms = []
inter = []
fasta = []

fasta_sequences = sys.stdin
prevLine = ""
entry = []
for line in fasta_sequences:
    names = re.match('>[a-z]+',line)
    if names:
        organisms.append(line.strip().split('>')[1])
    else:
        if len(prevLine) < len(line):
            entry = []
        else:
            entry.append(line.strip())
    prevLine = line
    if not entry:
        continue
    inter.append(entry)

for f in inter:
    fasta.append(''.join(f))
fasta = list(set(fasta))

gap_pos = []
fin_seq = []
for i in range(len(fasta)):
    if organisms[i] =='homo_sapiens':
        sequence = fasta[i]
        for m in re.finditer("([-]+)",sequence):
            gap_pos.append(m.start())
            gap_pos.append(m.end())
for j in range(len(fasta)):
    sequence=fasta[j][:-3]
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

print(str(len(organisms)) + " " + str(len(fin_seq[0])))
for i in range(len(fin_seq)):
    print(organisms[i] + "\n" +fin_seq[i])

