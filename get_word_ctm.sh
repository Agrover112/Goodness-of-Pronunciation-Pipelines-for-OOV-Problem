#!/usr/bin/bash
. ./path.sh
# Author: Ankit Grover
# Date :23/7/2022
# Following file gets you the word alignments in Kaldi
tra="ark:utils/sym2int.pl -f 2- $lang/words.txt $outFile|"
outFile=$1
$DIR/src/latbin/linear-to-nbest ark:$dir/ali/${temp}_ali  "$tra"  "" "" "ark:-" |
        $DIR/src/latbin/lattice-align-words $lang/phones/word_boundary.int "$dir/final.mdl" "ark:-" "ark:-" |
        $DIR/src/latbin/nbest-to-ctm ark:- - | utils/int2sym.pl -f 5- $lang/words.txt >$outFile
