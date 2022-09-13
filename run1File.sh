# Modified by Agrover112
fileIn=$1;
fileOut=$2;
currPWD=$PWD
#./cmd.sh
#./path.sh

set -e
echo "dir:",$dir,"SUIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"
echo $temp
sox $fileIn -r8000 -c1 -b16 $DIR3b/tmp.wav
echo "UTTERENCE_ID $DIR3b/tmp.wav"  > $DIR3b/wav.scp
echo "UTTERENCE_ID UTTERENCE_ID" > $DIR3b/spk2utt
echo "UTTERENCE_ID UTTERENCE_ID" > $DIR3b/utt2spk





$DIR/src/featbin/compute-mfcc-feats --verbose=2 --config=/home/${USER}/kaldi/egs/chiru/FA_wordTrans/conf/mfcc.conf scp,p:$DIR3b/wav.scp ark:- | $DIR/src/featbin/copy-feats --compress=true ark:- ark,scp:$DIR3b/mfcc_test.ark,$DIR3b/feats.scp


$DIR/src/featbin/compute-cmvn-stats --spk2utt=ark:$DIR3b/spk2utt scp:$DIR3b/feats.scp ark,scp:$DIR3b/cmvn_test.ark,$DIR3b/cmvn.scp


$currPWD/steps/online/nnet2/align.sh --nj 1 $DIR3b $lang $dir $dir/ali || exit 1
#$currPWD/steps/align_si.sh --nj 1 $DIR3b $lang $dir(exp/tri2b) $dir/ali
mv $dir/ali/ali.1.gz $dir/ali/${temp}_ali.gz
gunzip $dir/ali/${temp}_ali.gz

#./get_phone_alignment.sh "UTTERENCE_ID" $lang/phones.txt $dir/final.mdl $dir/ali/${temp}_ali $fileOut
$DIR/src/bin/show-alignments $lang/phones.txt $dir/final.mdl ark:$dir/ali/${temp}_ali > $currPWD/wavlib/lab/${temp}_alignment_infile.txt
./get_ctm.sh  "UTTERENCE_ID" $currPWD/wavlib/lab/${temp}_alignment_infile.txt $fileOut
#mv tmp.a $currPWD/wavlib/lab/${temp}_alignment_infile.txt

./get_word_ctm.sh $currPWD/wavlib/lab/${temp}_word_.ctm

#tra="ark:utils/sym2int.pl -f 2- $lang/words.txt $outFile|"
#$DIR/src/latbin/linear-to-nbest ark:$dir/ali/${temp}_ali  "$tra"  "" "" "ark:-" |
#       $DIR/src/latbin/lattice-align-words $lang/phones/word_boundary.int "$dir/final.mdl" "ark:-" "ark:-" |
#       $DIR/src/latbin/nbest-to-ctm ark:- - | utils/int2sym.pl -f 5- $lang/words.txt >$currPWD/wavlib/lab/"${temp}_word_.ctm"


#rm -rf $dir/ali/*
rm tmp.b tmp.c tmp.d tmp.e
