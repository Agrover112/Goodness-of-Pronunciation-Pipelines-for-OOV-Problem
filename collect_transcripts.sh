#!/bin/bash
# 
# Find all the transcripts present in the nested-folders and put them in one text-file
# Usage:
# bash collect_transcripts.sh ./train-clean-360/ transcript
# Output: other.txt
dir=$1
file=$2
cat $(find $dir -name "*.trans.txt") | cut -d' ' -f2- >${file}.txt
