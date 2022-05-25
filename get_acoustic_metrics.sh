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
wavDir=$PWD"/wavlib/wav";
#wavDir=$PWD"/wavlib/train_clean_example"
#transFile=$PWD"/wavlib/train_clean_example/trans.txt" #update this file with your trascriptions file
transFile=$PWD"/wavlib/wav/1272-128104.trans.txt"
#outFile=$PWD"/data/split1/1/text";
outFile=$PWD"/wavlib/data/split1/1/text"
#outDir=$PWD"/lab"; # update this variable with your destination folder
outDir=$PWD"/wavlib/lab"

generate_alignment_infile_posteriors
