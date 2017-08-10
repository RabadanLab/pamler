import json,sys

data = json.load(sys.stdin)

org = []
seq = []
perc = []

for entries in data:
	org.append(entries['type'])
	seq.append(entries['seq'])
	perc.append(entries['perc_id'])

# identify duplicate organisms and their indices
dup_idx = [i for i, x in enumerate(org) if org.count(x) > 1]
dup = {}

if not dup_idx:
	# print('no duplicates')
	for j in range(len(org)):
		print(">" + org[j])
		print(seq[j])
else:
	# print('there are duplicates')
	for i in range(len(dup_idx)):
		dup[dup_idx[i]] = perc[dup_idx[i]]

	# find the sequence with the higest percent identity
	max_perc = (max(dup.values()))

	for idx, percent in dup.iteritems():
		if percent == max_perc:
			max = idx
	dup_idx.remove(int(max))

	# delete the sequences with lower percent identity
	for dels in dup_idx:
		del org[dels]
		del seq[dels]
		del perc[dels]

	# write to fasta file
	for j in range(len(org)):
		print(">" + org[j])
		print(seq[j])

