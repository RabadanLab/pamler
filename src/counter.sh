#!/bin/bash
echo $(ls | wc -l)/2 | tr -d ',' | perl -ne 'print eval . "\n"'
