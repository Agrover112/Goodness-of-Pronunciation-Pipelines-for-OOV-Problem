#! /bin/bash
### First time, run the run.sh by replacing your trascriptions in the data/allTrans.txt and your dictionary in the data/local/dict/mySrcDict.
## Update wavDir accordingly.

set -e

fileIn=$1;
fileOut=$2;
##wavDir="/";
wavDir=$3
transFile=$4
##transFile="/home/chiranjeevi/kaldi/egs/chiru/FA_wordTrans/data/allTrans.txt" #update this file with your trascriptions file
outFile=$5
##outFile="/home/chiranjeev_ui/kaldi/egs/chiru/FA_wordTrans/data/split1/1/text";
currPWD=$PWD
mkdir -p $currPWD/wavlib/lab/posteriors
#outDir="/home/spireserver/voistutor-trash/"; # update this variable with your destination folder
#mkdir -p $outDir

i=$fileIn;
temp=`echo $fileOut | rev | cut -d"." -f2 | cut -d"/" -f1 | rev`;
echo $temp

#echo "UTTERENCE_ID" `cat $transFile | grep "\b"$temp" " | cut -d" " -f2- |sed "s/ (/=/g" | cut -d"=" -f1 | sed "s/) /=/g" | cut -d"=" -f2- | sed "s/'/XXXXX/g" | tr '[:punct:]' ' ' | tr -s " " | sed "s/XXXXX/'/g" | sed "s/ '/ /g" | tr '[A-Z]' '[a-z]'` > $outFile
#awk '{gsub("([0-9]+-[0-9]+-[0-9]+)","UTTERANCE_ID",$1)}1' $transFile >$outfile
#cd "/home/chiranjeevi/kaldi/egs/chiru/FA_wordTrans/";

sox $i -r8000 -c1 -b16 $DIR3b/tmp.wav
echo "UTTERENCE_ID $DIR3b/tmp.wav"  > $DIR3b/wav.scp
echo "UTTERENCE_ID UTTERENCE_ID" > $DIR3b/spk2utt
echo "UTTERENCE_ID UTTERENCE_ID" > $DIR3b/utt2spk
mfcc_config="/home/chiranjeevi/kaldi/egs/chiru/FA_wordTrans/exp/nnet2_online/nnet_ms_a_online/conf/mfcc.conf"
ivec_config="/home/chiranjeevi/kaldi/egs/chiru/FA_wordTrans/exp/nnet2_online/nnet_ms_a_online/conf/ivector_extractor.conf"

$DIR/src/featbin/compute-mfcc-feats --verbose=2 --config=$mfcc_config scp,p:$DIR3b/wav.scp ark:- | $DIR/src/featbin/copy-feats --compress=true ark:- ark,scp:$DIR3b/mfcc.ark,$DIR3b/feats.scp

$DIR/src/featbin/compute-cmvn-stats --spk2utt=ark:data/spk2utt scp:$DIR3b/feats.scp ark,scp:$DIR3b/cmvn.ark,$DIR3b/cmvn.scp

$DIR/src/featbin/copy-feats ark:$DIR3b/mfcc.ark ark,t:$DIR3b/txt.ark

$DIR/src/online2bin/ivector-extract-online2 --config=$ivec_config ark:$DIR3b/spk2utt scp:$DIR3b/feats.scp ark,t:$DIR3b/ivectors.1.ark

$DIR/src/featbin/copy-feats ark:$DIR3b/ivectors.1.ark ark,t:$DIR3b/ivectors.ark.txt

$DIR/src/featbin/subsample-feats --n=-10 ark:$DIR3b/ivectors.ark.txt ark,t:$DIR3b/ivectors_exp.ark

$DIR/src/featbin/paste-feats --length-tolerance=10 ark:$DIR3b/txt.ark ark:$DIR3b/ivectors_exp.ark ark,t:$DIR3b/feats-out.ark

$DIR/src/nnet2bin/nnet-am-compute $dir/final.mdl ark:$DIR3b/feats-out.ark ark,t:$currPWD/wavlib/lab/posteriors/${temp}.ark
#temp=`echo $fileIn | rev | cut -d"." -f2 | cut -d"/" -f1 | rev`;
#mv $DIR3b/post.ark $currPWD/posteriors/${temp}_posterior_infile.ark
#cat $DIR3b/post.ark | sed '1d' | sed 's/]//g;s/^[ \t]*//g;s/[ \t]*$//g'> $fileOut
