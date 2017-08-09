import json,sys

data = json.load(sys.stdin)
for i in data:
    #print(">" + i["id"] + "\t" + i["type"])
    print(">"  + i["type"])
    print(i["seq"])

# data is a list of dicts

# write to fasta file

