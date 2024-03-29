fileIn=$1;
fileOut=$2;
currPWD=$PWD

#./cmd.sh
#./path.sh

set -e


sox $fileIn -r8000 -c1 -b16 $DIR3b/tmp.wav
echo "UTTERENCE_ID $DIR3b/tmp.wav"  > $DIR3b/wav.scp
echo "UTTERENCE_ID UTTERENCE_ID" > $DIR3b/spk2utt
echo "UTTERENCE_ID UTTERENCE_ID" > $DIR3b/utt2spk


$DIR/src/featbin/compute-mfcc-feats --verbose=2 --config=/home/${USER}/kaldi/egs/chiru/FA_wordTrans/conf/mfcc.conf scp,p:$DIR3b/wav.scp ark:- | $DIR/src/featbin/copy-feats --compress=true ark:- ark,scp:$DIR3b/mfcc_test.ark,$DIR3b/feats.scp


$DIR/src/featbin/compute-cmvn-stats --spk2utt=ark:$DIR3b/spk2utt scp:$DIR3b/feats.scp ark,scp:$DIR3b/cmvn_test.ark,$DIR3b/cmvn.scp


steps/online/nnet2/align.sh --nj 1 $DIR3b $lang $dir $dir/ali || exit 1

rm -rf $dir/ali/ali.1
gunzip $dir/ali/ali.1.gz
./get_phone_alignment.sh "UTTERENCE_ID" $lang/phones.txt $dir/final.mdl $dir/ali/ali.1 $fileOut
mv tmp.a $currPWD/wavlib/lab/${temp}_alignment_infile.txt
