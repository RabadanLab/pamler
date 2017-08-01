#!/bin/bash
# This script pulls a fasta object containing `>homo` header to the top. This is necessary to post-process output file from CODEML
# 
#  Usage:
#  $cat tmp_proc.fa | bash src/fasta_homo_puller.sh  # take input from STDIN
#  $bash src/fasta_homo_puller.sh tmp_proc.fa        # take input from a positional argument


TEMPFILE=$(mktemp )
cat $1 > $TEMPFILE

cat <(perl -ne 'if(/^>/){chomp; print $_."\t"; } else {print}' ${TEMPFILE} | grep homo) <(perl -ne 'if(/^>/){chomp; print $_."\t"; } else {print}' ${TEMPFILE} | grep -v homo) | tr '\t' '\n'

rm ${TEMPFILE}
