#!/bin/bash


NO_REMOVE_GAPS=0
SPECIES="homo_sapiens"
# bash opt
while true; do
    case "$1" in
    	--noremovegaps) NO_REMOVE_GAPS=1; shift ;;
        --species) SPECIES="$2"; shift 2;;
	*) break;;
    esac
done
MLC_FILE="$1" # data/branchsite_SIGN_dec_5/SIGN_model_interacting/ZNRF4.HA.mlc


# prints fasta file
FASTA_FILE=$(mktemp)
trap 'rm -rf "$FASTA_FILE"' EXIT

if [[ ${NO_REMOVE_GAPS} == 1 ]]; then
  bash src/mlc2fasta.sh --noremovegaps --species ${SPECIES} $MLC_FILE > ${FASTA_FILE}
else 
  bash src/mlc2fasta.sh --species "${SPECIES}" $MLC_FILE > ${FASTA_FILE}
fi

# converts to aa
PEP_FILE=$(mktemp)
trap 'rm -rf "$PEP_FILE"' EXIT
Rscript src/nuc2aa.R $FASTA_FILE $PEP_FILE

cat ${PEP_FILE}


