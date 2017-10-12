#!/bin/bash
# How to run
# run_paml.sh <GENE_NAME>

# command and output
run() {
    local command="$1"
    local output="$2"

    echo " -> $command"
    #if [[ -e $output ]]; then
	#  echo "$output already exists! skipping..."
    #else
	echo "$command" | sh
    #fi
    echo ""

}


GENE_NAME=$1
OUTPUTDIR=data/interim/paml_results/${GENE_NAME}

if [[ ! -e $OUTPUTDIR ]]; then

    echo "[MESSAGE] Making ${OUTPUTDIR}"
    run "mkdir -p ${OUTPUTDIR}"
fi


# Parameters
PHYLIP_PATH=${GENE_NAME}.phy
TREE_PATH=${GENE_NAME}.tree
H0_PATH=h0.res
H0_CTL=h0.ctl
H1_PATH=h1.res
H1_CTL=h1.ctl
FASTA_PATH=data/fasta/5_aligned-species-filtered
FASTA_SUFFIX=_filtered.aligned.fa.best.nuc.fas
PRUNED_TREE_PATH=data/phyml/phyml-pruned
PRUNED_TREE_SUFFIX=.pruned.tree



echo "[MESSAGE] Generate phylip format from alignment"
run "cat ${FASTA_PATH}/${GENE_NAME}${FASTA_SUFFIX}| awk -f src/fastajoinlines | bash src/fasta_homo_puller.sh | python src/fa2phy.py  > ${OUTPUTDIR}/${PHYLIP_PATH}" ${OUTPUTDIR}/${PHYLIP_PATH}

echo "[MESSAGE] Generate tree"
run "cat ${PRUNED_TREE_PATH}/${GENE_NAME}${PRUNED_TREE_SUFFIX}| perl -pe 's/homo_sapiens/homo_sapiens#1/' > ${OUTPUTDIR}/${TREE_PATH}" ${OUTPUTDIR}/${TREE_PATH}


run "bash assets/H0neutrality.sh ${PHYLIP_PATH} ${TREE_PATH}  ${H0_PATH} > ${OUTPUTDIR}/${H0_CTL}" ${OUTPUTDIR}/${H0_CTL}

run "bash assets/HAselection.sh ${PHYLIP_PATH} ${TREE_PATH}  ${H1_PATH} > ${OUTPUTDIR}/${H1_CTL}" ${OUTPUTDIR}/${H1_CTL}


#if cd ${OUTPUTDIR}; then
#    echo $(pwd)
#    run "codeml $(basename ${H0_CTL})"
#    run "codeml $(basename ${H1_CTL})"
#fi




