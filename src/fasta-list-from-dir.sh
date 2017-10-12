#!/bin/bash
# list the unique gene names in a directory
# This script assumes that gene name is in front 

DELIM="_"


# bash opt
while true; do
    case "$1" in
	--delim|-d) DELIM="$2"; shift 2;;
	*) break;;
    esac
done

TARGET_DIR=$1

ls $TARGET_DIR | cut -f1 -d${DELIM} | sort | uniq
