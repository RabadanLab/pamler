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



# TODO

* [ ] gene --> tidy data for site specific dnds 
    * [ ] alignment format issue: muscle/clustalw produces an alignment
    * [ ] rst parser



