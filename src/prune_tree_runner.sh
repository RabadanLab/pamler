#!/bin/bash


run_pruner() {
  GENE=$1
  Rscript src/prune_tree.R data/phyml/phyml-unpruned/${GENE}.phy_phyml_tree.txt data/fasta/5_aligned-species-filtered/${GENE}_filtered.aligned.fa.best.nuc.fas  data/phyml/phyml-pruned/${GENE}.pruned.tree
}

export -f run_pruner

ls data/fasta/5_aligned-species-filtered \
       | cut -f1 -d_  \
       | sort  \
       | uniq \
       | parallel 'run_pruner {}'
