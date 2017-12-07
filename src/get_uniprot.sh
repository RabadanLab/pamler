#!/bin/bash


GENE="$1" # TP53

UNIPROT_ID=$(grep -w ${GENE} assets/pep2uniprot_gorka.txt | cut -f2)

if [[ -z ${UNIPROT_ID} ]]; then
    echo "Uniprot ID unavailable for : ${GENE}"
    exit 1
fi
curl "http://www.uniprot.org/uniprot/${UNIPROT_ID}.fasta" 
