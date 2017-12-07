#!/bin/bash

GENE=$1
DEBUG=0
RE=1
function echo2() {
    if [[ $DEBUG == 1 ]]; then
      echo "$1"
  fi
}

if [[ -z $GENE ]]; then
    echo "Usage: match-pep.sh <GENE_NAME>"
    exit 1
fi

UNIPROT_ID=$(grep -w ${GENE} assets/pep2uniprot_gorka.txt | cut -f2)

if [[ -z ${UNIPROT_ID} ]]; then
    echo "Uniprot ID unavailable for : ${GENE}"
    exit 1
fi
UNIPROT_SEQ=tmp/${GENE}.uniprot.pep
PRANK_SEQ=data/fasta/5_aligned-species-filtered/${GENE}_filtered.aligned.fa.best.pep.fas
PRANK_SEQ_RMGAP=tmp/${GENE}.rmgap.pep
#PRANK_SEQ_RMGAP=tmp/${GENE}.rmgap_length_match_but_diff.pep
GENE_MATCHING_TBL=tmp/${GENE}.tbl.txt
BLAST_OUT=tmp/${GENE}.pep.blast

echo2 "---------------------------------------------------------------------------"
echo2 "GENE : ${GENE}"
echo2 "uniprot id: ${UNIPROT_ID}"
echo2 "---------------------------------------------------------------------------"
echo2 ""
echo2 "Step 0 - obtain uniprot"

if [[ ! -e ${UNIPROT_SEQ} ]]; then
    echo2 "uniprot sequence ${UNIPROT_ID} doesn't exist in $(dirname $UNIPROT_SEQ). Downloading..."
    echo2 "curl http://www.uniprot.org/uniprot/${UNIPROT_ID}.fasta > ${UNIPROT_SEQ} "
    curl "http://www.uniprot.org/uniprot/${UNIPROT_ID}.fasta" > ${UNIPROT_SEQ} 
fi

echo2 "Step 1 - Prprocess PRANK seq"
if [[ ! -e ${PRANK_SEQ_RMGAP} || ! -e ${GENE_MATCHING_TBL} ]]; then
  python src/match-pep.py ${PRANK_SEQ} ${PRANK_SEQ_RMGAP} ${GENE_MATCHING_TBL}
fi

echo2 "Step 2 - Blast"
if [[ ! -e ${BLAST_OUT} || ${RE} == 1 ]]; then
    blastp -gapopen 6 -gapextend 2 -subject ${UNIPROT_SEQ} -query ${PRANK_SEQ_RMGAP} -outfmt 15 -out ${BLAST_OUT}
fi

echo2 "Step 3 - Analyze Blast results"
#cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0]'

SUBJECT_LEN=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].len')
#QUERY_LEN=$(cat ${PRANK_SEQ_RMGAP}  | fastalength2 | cut -f2)
QUERY_LEN=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].query_len')


SUBJECT_FROM=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0].hit_from')
SUBJECT_TO=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0].hit_to')
QUERY_FROM=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0].query_from')
QUERY_TO=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0].query_to')
IDENTITY=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0].identity')
ALIGN_LEN=$(cat ${BLAST_OUT} | jq '.BlastOutput2[0].report.results.bl2seq[0].hits[0].hsps[0].align_len')
PERC_IDENTITY=$(echo "${IDENTITY} ${ALIGN_LEN}" | awk '{print ($1/$2) * 100 }')

echo -n "${GENE},"
if [[ $DEBUG == 1 ]]; then
  echo "SUBJECT_FROM - QUERY_FROM"
  echo "$SUBJECT_FROM - $QUERY_FROM"
  echo "---"
  echo "SUBJECT_TO - QUERY_TO"
  echo "$SUBJECT_TO - $QUERY_TO"
  echo "---"
  echo "SUBJECT_LEN - QUERY_LEN - ALIGN_LEN - IDENTITY - PERC IDENTITY"
  echo "$SUBJECT_LEN - $QUERY_LEN - ${ALIGN_LEN} - ${IDENTITY} - ${PERC_IDENTITY}"
fi

#if [[ $HIT_FROM == $QUERY_FROM && $HIT_TO == $QUERY_TO && $IDENTITY == $SUBJECT_LEN ]]; then
if [[ ${QUERY_LEN} > ${SUBJECT_LEN} ]]; then
    echo -n 2 #"Query is longer than subject"
elif [[ ${QUERY_LEN} < ${SUBJECT_LEN} ]]; then
    echo -n 1 # "Subject  is longer than query"
else
    echo -n 0
fi

if [[ ${PERC_IDENTITY} == 100 && ${QUERY_LEN} == ${SUBJECT_LEN} ]]; then
    echo -n 0 #"Perfect Match!"
# elif [[ ${IDENTITY} == ${SUBJECT_LEN} && ${PERC_IDENTITY} != 100 ]]; then
#     echo "Length Same - but Mismatch!"
# elif [[ ${IDENTITY} < ${SUBJECT_LEN} && ${PERC_IDENTITY} == 100 ]]; then
#     echo "Match - but gap"
else 
    echo -n 1 # "Not perfect Match!"

fi

if [[ $SUBJECT_FROM == 1 ]]; then
    echo -n 0 # Starts from the begining
else
    echo -n 1 # Starts from the begining
fi

echo ""
