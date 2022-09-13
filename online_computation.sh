#!/bin/bash
# Author: Ankit Grover
# Date: 27/6/2022
. ./path.sh
. ./cmd.sh
currPWD=$PWD
libri_path="../librispeech/s5"

db1="/home/${USER}/kaldi/egs/librispeech/s5/data/local/dict_nosp/cmudict.0.7a.plain"
db2="/home/${USER}/kaldi/egs/librispeech/s5/data/local/lm/librispeech-vocab.txt"
lexicon="/home/${USER}/kaldi/egs/librispeech/s5/data/local/dict_nosp/lexicon_raw_nosil.txt"
# cp old-lexicon _appended
# initialize with langer first, copy dir phones to nnet phones
#lexicon="/home/${USER}/kaldi/egs/librispeech/s5/data/local/dict_nosp/lexicon_raw_nosil_appended.txt" #HYBRID

function add_silences_to_lexicon
{
        file=$1;
        sed -i '1s/^/!SIL SIL\n/' $file
        sed -i '2s/^/<SPOKEN_NOISE> SPN\n/' $file
        sed -i '3s/^/<UNK> SPN\n/' $file
}

function generate_extra_quetsions
{
  silence_phones=wavlib/data/local/dict/online_dict/silence_phones.txt
  optional_silence=wavlib/data/local/dict/online_dict/optional_silence.txt
  nonsil_phones=wavlib/data/local/dict/online_dict/nonsilence_phones.txt
  extra_questions=wavlib/data/local/dict/online_dict/extra_questions.txt


  echo "Preparing phone lists and clustering questions"
  (echo SIL; echo SPN;) > $silence_phones
  echo SIL > $optional_silence
  # nonsilence phones; on each line is a list of phones that correspond
  # really to the same base phone.
  awk '{for (i=2; i<=NF; ++i) { print $i; gsub(/[0-9]/, "", $i); print $i}}' file_lexicon.txt |\
    sort -u |\
    perl -e 'while(<>){
      chop; m:^([^\d]+)(\d*)$: || die "Bad phone $_";
      $phones_of{$1} .= "$_ "; }
      foreach $list (values %phones_of) {print $list . "\n"; } ' | sort \
      > $nonsil_phones || exit 1;
  # A few extra questions that will be added to those obtained by automatically clustering
  # the "real" phones.  These ask about stress; there's also one for silence.
  cat $silence_phones| awk '{printf("%s ", $1);} END{printf "\n";}' > $extra_questions || exit 1;
  cat $nonsil_phones | perl -e 'while(<>){ foreach $p (split(" ", $_)) {
    $p =~ m:^([^\d]+)(\d*)$: || die "Bad phone $_"; $q{$2} .= "$p "; } } foreach $l (values %q) {print "$l\n";}' \
    >> $extra_questions || exit 1;
  echo "$(wc -l <$silence_phones) silence phones saved to: $silence_phones"
  echo "$(wc -l <$optional_silence) optional silence saved to: $optional_silence"
  echo "$(wc -l <$nonsil_phones) non-silence phones saved to: $nonsil_phones"
  echo "$(wc -l <$extra_questions) extra triphone clustering-related questions saved to: $extra_questions"
}
#


function oov_pipeline
{
        echo "OOV found.........";
        sudo bash $currPWD/get_failed_entries.sh not_both1.txt
        mv file_lexicon.txt file_lexicon_temp.txt
        cat file_lexicon_temp.txt | tr "\t" " " | tr -s " " | cat - $lexicon | sort | uniq>file_lexicon.txt  #Check
        cp file_lexicon.txt $currPWD
        #cp file_lexicon.txt  $lexicon # HYBRID
        rm -f wavlib/data/local/dict/online_dict/lexiconp.txt
        cd "$currPWD"  || exit 1; # Outside Libri

        ## raw_lexicon creation ends

        mkdir -p  wavlib/data/local/dict/online_dict/  # Add ID

        ## Generate the silence_phones, extra_questions, etc required for prepare_lang.sh
        ## this is required for decison tree based phonetic tree state tying
        generate_extra_quetsions
##
##

        ## Copy and move file_lexicon to dictionary path
        cp file_lexicon.txt wavlib/data/local/dict/online_dict/.
        mv wavlib/data/local/dict/online_dict/file_lexicon.txt wavlib/data/local/dict/online_dict/lexicon.txt
##

        add_silences_to_lexicon wavlib/data/local/dict/online_dict/lexicon.txt
        ## Generate L.fst, L_disambiguation.fst, other stuff required for (HoCoL).fst composition

        rm -f wavlib/data/local/dict/online_dict/lexiconp.txt
        sudo bash utils/prepare_lang.sh wavlib/data/local/dict/online_dict "<UNK>" wavlib/data/local/lang_online_temp  wavlib/data/lang_onlin  # *notice : It's "onlin" not "online"

        chmod ugo+rwx wavlib/data/lang_onlin/*

##


        echo "========== Setting compatible phones ======="
        ## Set compatible phones
        cp wavlib/data/lang_onlin/phones.txt wavlib/exp/nnet2_online/nnet2_er/.
        #cp wavlib/data/lang_hybrid/phones.txt wavlib/exp/nnet2_online/nnet2_er/  HYBRID

        ## Remove online_dict contents at end
        #rm -rf wavlib/data/local/dict/online_dict/
        #rm -f wavlib/data/lang_onlin/*
        rm -f trans_vocab.txt
        rm -f file_lexicon.txt
        #rm -f $libri_path/not_cmu.txt
        #rm -f $libri_path/not_both1.txt


}





function main
{

transcript=$1
#hybrid=1
cat $transcript | tr "\t" " " | tr -s " " |  cut -d" " -f2- |
 tr " " "\n" > trans_vocab.txt


#cat $PWD"/wavlib/data/split1/1/text" | tr "\t" " " | tr -s " " |  cut -d" " -f2- |
# tr " " "\n" > trans_vocab.txt

## Generate Lexicon
##

cd $libri_path || exit 1; # In Libri
sudo bash $currPWD/find_oov.sh $db1 $db2 $currPWD/trans_vocab.txt

if [ -s not_both1.txt ];
then
        oov_pipeline;
else
        echo "No OOV ...continuing as mormal";
fi
}

main "$@"
