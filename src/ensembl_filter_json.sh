#!/bin/bash

# bash opt
while true; do
    case "$1" in
    	--raw) RAW=1; shift ;;
	*) break;;
    esac
done
GENE="$1"
SEQUENCE_TYPE="$2" # 'protein' or 'cdna'
TAXON_PRIMATE=9443



if [[ -z $GENE ]]; then
    echo "No gene is provided!"
    exit 1
fi

if [[ -z $SEQUENCE_TYPE ]]; then
    SEQUENCE_TYPE=cdna
fi

function curl_cmd(){
    curl "https://rest.ensembl.org/homology/symbol/human/${GENE}?target_taxon=${TAXON_PRIMATE}&type=orthologues&sequence=${SEQUENCE_TYPE}&aligned=0" -H 'Content-type:application/json' 
}


tempfile=$(mktemp)

curl_cmd > ${tempfile}

if [[ $RAW == 1 ]]; then
    cat ${tempfile}
else 

    if [[ $SEQUENCE_TYPE == "protein" ]]; then
        jq -s '.' \
        <(cat ${tempfile} | jq '.data[0].homologies[0] | { type: .source.species, seq: .source.seq, id: .source.protein_id }') \
        <(cat ${tempfile}| jq '.data[0].homologies[] | { dn_ds: .dn_ds, type: .target.species, seq: .target.seq, id: .target.protein_id }' )
    else 
        jq -s '.' \
        <(cat ${tempfile} | jq '.data[0].homologies[0] | { type: .source.species, seq: .source.seq, id: .source.id }' ) \
        <(cat ${tempfile}| jq '.data[0].homologies[] | { dn_ds: .dn_ds, type: .target.species, seq: .target.seq, id: .target.id }')
    fi
fi

rm ${tempfile}
