#!/usr/bin/bash

# Author: Ankit Grover 
# Date :23/3/2022
# Place the folders amd sbufolders of data , exp in this directoryi

function generate_alignment_infile_posteriors()
{
local out=10
: '
This function will generate the alignment_infile.txt and posterior_infile.ark
'

echo "Generating alignments .........."

./runAllFiles.sh $wavDir $transFile $outFile $outDir  #&>/dev/null
status=$?
#echo $status
#[ ! $status -eq 0 ] && { echo "Exited with errors" & exit 1; } || echo "Alignments generated ........" 

}


# Update these locations to run properly 

wavDir=$1 #wavDir=$PWD"/wavlib/wav";
transFile=$2  #transFile=$PWD"/wavlib/wav/1272-128104.trans.txt"  #update this file with your trascriptions file
outDir=$3     #outDir=$PWD"/wavlib/lab"
 

outFile=$PWD"/wavlib/data/split1/1/text"



generate_alignment_infile_posteriors
