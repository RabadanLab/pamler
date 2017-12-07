#!/bin/bash
# This script produces a matching table between sequenced used in codeml and uniprot sequence
# Usage: match-pep.sh <GENE> <MLC_PATH> 

GENE="$1" 
MLC_PATH="$2"

GAP_PRESERVING_NUC=${GENE}.gapped.human 
ENSEMBL_PEP=${GENE}.ensembl.pep
UNIPROT=${GENE}.uniprot.pep
COMBINED=${GENE}.combined.pep
COMBINED_ALIGNED=${GENE}.combined.aligned.pep

# Obtain Gap-preserving nucleotide
bash src/mlc2fasta.sh --noremovegaps --species "homo_sapiens" ${MLC_PATH} > ${GAP_PRESERVING_NUC}

# Align  ours and uniprot sequence
bash src/mlc2aa.sh ${MLC_PATH} > ${ENSEMBL_PEP} 
bash src/get_uniprot.sh ${GENE} > ${UNIPROT}
cat ${ENSEMBL_PEP} ${UNIPROT} > ${COMBINED}
muscle -in ${COMBINED} 2> /dev/null > ${COMBINED_ALIGNED}

# Produce a matching table
Rscript src/matcher.R ${GAP_PRESERVING_NUC} ${COMBINED_ALIGNED} > ${GENE}.matching.table

Rscript src/align_summary.R ${COMBINED_ALIGNED} > ${GENE}.matching.summary

# Clean up
#rm -rf ${UNIPROT:?}
#rm -rf ${ENSEMBL_PEP:?}
#rm -rf ${COMBINED:?}
#rm -rf ${COMBINED_ALIGNED:?}
#rm -rf ${GAP_PRESERVING_NUC:?}

