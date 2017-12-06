#!/bin/bash

MLC_FILE="$1" # data/branchsite_SIGN_dec_5/SIGN_model_interacting/ZNRF4.HA.mlc

# prints fasta file
FASTA_FILE=$(mktemp)
trap 'rm -rf "$FASTA_FILE"' EXIT
bash src/mlc2fasta.sh $MLC_FILE > ${FASTA_FILE}

# converts to aa
PEP_FILE=$(mktemp)
trap 'rm -rf "$PEP_FILE"' EXIT
Rscript src/nuc2aa.R $FASTA_FILE $PEP_FILE

cat tmp.pep


