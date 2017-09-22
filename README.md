# PAMLer

PAML on steroids, basically. 

With this pipeline, we want to compute site-specific dn/ds for ~4000 genes that have interfacial residues interacting with virus. 

Contributors: Kernyu and Albert

# Objective

Make the following pipeline

![](assets/pipeline-20170725.png)

# How to use it

* Install `jq` first

    # Download CCR5 cdna using ENSMBL API
    $bash src/ensembl_filter_json.sh CCR5 cdna | python src/json2fasta.py
    # Download CCR5 protein using ENSMBL API
    $bash src/ensembl_filter_json.sh CCR5 protein | python src/json2fasta.py

    # Generate a prune tree
    $Rscript src/prune_tree.R assets/primates_input_JA.tre FASTA OUTPUT_TREE 

    # Alignment using MUSCLE
    $bash src/ensembl_filter_json.sh CCR5 cdna | python src/json2fasta.py > CCR5.fa && muscle -in CCR5.fa # this produces a fasta format that is to be parsed and converted to phylip format that can be handled by PAML.

    # Filter Outlier Species Using Gap from Sequence Alignments
    $bash src/ensembl_filter_json.sh CCR5 cdna | python src/json2fasta.py > CCR5.fa && muscle -in CCR5.fa | awk -f src/fastajoinlines | python src/gap_filter.py CCR5

    # Parse Multiple Sequence Alignment Results
    $bash src/ensembl_filter_json.sh CCR5 cdna | python src/json2fasta.py > CCR5.fa && muscle -in CCR5.fa | awk -f src/fastajoinlines | python src/gap_filter.py CCR5 | muscle -tree2 ../CCR5.fa | awk -f src/fastajoinlines | bash src/fasta_homo_puller.sh | python src/stop_gap.py | python src/fa2phy.py > ../CCR5.phy

    # Generate PAML ctl file
    $bash src/generate_template.ctl.sh <alignment> <tree> <outputfile> > tmp.ctl

# Logs

## 2017/09/20: Alignment & Estimating the tree brach length

    # Generate interleaved phylip & estimate branch length
    Rscript src/fa2phyinter.R CCR5 data/fasta data/phylip && phyml -i data/phylip/CCR5.phy -d nt -b 0 -m GTR -c 4 -a 1 -u  data/pruned_tree/CCR5.tree -o lr
    # Generate interleaved phylip & estimate branch length FOR All genes
    ls data/fasta/*fa | parallel --dry-run "Rscript src/fa2phyinter.R {/.} data/fasta data/phylip && phyml -i data/phylip/{/.}.phy -d nt -b 0 -m GTR -c 4 -a 1 -u  data/pruned_tree/{/.}.tree -o lr" | bash

## 2017/09/21: Translation aware alignment

$prank -d=data/fasta/CCR5.fa -o=output_translated -translate -F


# Exceptions

* 2017/09/21 Moved the gene `ABCA13` from `data/fasta/`, `data/fasta-aligned/`, and `data/pruned_tree/` to data/exceptions. Will not process this gene because it contains the sequence that's long and it fails in muscle step which is necessary for branch length estimation

# TODO

* [ ] gene --> tidy data for site specific dnds 
    * [ ] alignment format issue: muscle/clustalw produces an alignment
    * [ ] rst parser



