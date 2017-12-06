#!/bin/bash

MLC_FILE=$1 # ex: data/branchsite_SIGN_dec_5/SIGN_model_interacting//ZNRF4.HA.mlc 

if [[ ! -e $MLC_FILE ]]; then
    echo "mlc2fasta.sh <MLC>"
    exit 1
fi

grep "homo_sapiens" $MLC_FILE | head -1 | tr -d ' ' | perl -ne 's/^homo_sapiens//; print ">homo_sapiens\n$_"'
