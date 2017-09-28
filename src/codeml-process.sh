#!/bin/bash


# bash opt
while true; do
    case "$1" in
    --outputdir|-o) OUTPUTDIR=$2; shift 2;;
    --help|-h) ;;
	--version|-v) ;;
	--usage) ;;
	--man);;
	*) break;;
    esac
done

if [[ -z ${OUTPUTDIR} ]]; then
    echo "Need to provide --outputdir"
    exit 1
fi

echo "find  $OUTPUTDIR -maxdepth 1 -type d | xargs basename | xargs -I{} echo \"cat ${OUTPUTDIR}/{}/h1.res | src/codeml-possite-extractor.sh > ${OUTPUTDIR}/{}/h1.psite.fwf\" | bash"
