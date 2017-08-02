#!/usr/bin/env python
import sys, os, re

organisms = []
fasta = []

fasta_input = sys.stdin
for line in fasta_input:
	names = re.match('>[a-z]+',line)
	if names:
		organisms.append(line.strip())
	else:
		fasta.append(line.strip())

print(str(len(organisms)) + " " + str(len(fasta[0])))
for i in range(len(fasta)):
	name = organisms[i].replace('>','')
	print(name + '\n' + fasta[i])