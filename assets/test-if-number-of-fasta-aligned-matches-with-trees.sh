#!/bin/bash


echo "Testing various Ns"
echo "- - Number of branch length estimated trees"
ls data/phylip/*tree.txt | wc -l
echo "- - Number of fasta files"
ls data/fasta/* | wc -l
echo "- - Number of pruned trees"
ls data/pruned_tree/*tree | wc -l

echo "-------------------------------------------------"
echo "Comparing the size of pruned_trees AND fasta-algined"

TMPFILE1=$(mktemp)
TMPFILE2=$(mktemp)
ls data/pruned_tree/*tree | parallel --dry-run "{/.}" | sort  > ${TMPFILE1}
ls data/fasta-aligned | cut -f1 -d. | sort | uniq > ${TMPFILE2}
echo "- - Checking left venn diagram size"
comm -23 ${TMPFILE1} ${TMPFILE2}  | wc -l

echo "- - Checking right venn diagram size"
comm -13 ${TMPFILE1} ${TMPFILE2}  | wc -l

echo "- - Checking Intersection"
comm -12 ${TMPFILE1} ${TMPFILE2}  | wc -l

rm ${TMPFILE2}
rm ${TMPFILE1}
