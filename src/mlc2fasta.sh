#!/bin/bash

NO_REMOVE_GAP=0
SPECIES="homo_sapiens"
# bash opt
while true; do
    case "$1" in
	--noremovegaps) NO_REMOVE_GAP=1; shift ;;
	--species) SPECIES="$2"; shift 2;;
	*) break;;
    esac
done
MLC_FILE=$1 # data/branchsite_SIGN_dec_5/SIGN_model_interacting/ZNRF4.HA.mlc 

if [[ ! -e $MLC_FILE ]]; then
    echo "mlc2fasta.sh <MLC>"
    exit 1
fi

if [[ $NO_REMOVE_GAP == 1 ]]; then
    grep ${SPECIES} $MLC_FILE | head -1 | perl -pe 's/^(\w+)\s{2,}/>$1\n/; s/ //g' | sed 's/NNN$//'
else
    grep ${SPECIES} $MLC_FILE | head -1 | perl -pe 's/^(\w+)\s{2,}/>$1\n/; s/ //g' | tr -d '-' | sed 's/NNN$//'
fi
