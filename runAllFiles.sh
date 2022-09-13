### First time, run the run.sh by replacing your trascriptions in the data/allTrans.txt and your dictionary in the data/local/dict/mySrcDict.
## Update wavDir accordingly.
 set -e
wavDir=$1;
transFile=$2 #update this file with your trascriptions file
outFile=$3;
outDir=$4; # update this variable with your destination folder
currPWD=$PWD
mkdir -p $outDir

export DIR="/home/${USER}/kaldi";
export DIR1b=$PWD"/wavlib/exp";
#export DIR1b=$PWD/"exp"
export DIR3b=$PWD"/wavlib/data"
#export DIR3b=$PWD"/data"
#export lang=$DIR3b"/lang"              MAKE SURE TO REPLACE lang_* with langer before starting any experiment or reruns.
#export lang=$PWD"/wavlib/data/langer"  # OOV present
export lang=$PWD"/wavlib/data/lang_nt" # Offline mode
#export lang=$PWD"/wavlib/data/lang_onlin" # Online mode
#export lang=$PWD"/wavlib/data/lang_hybrid" # Hybrid mode

export mfccdir=mfcc

export online_ivector_dir=$DIR1b"/nnet2_online/ivectors_train";
export dir=$DIR1b"/nnet2_online/nnet2_er";
export transform_dir=$DIR1b"/tri5a";


echo "Before loop"
for file in $(find "${wavDir}/" -type f -iname "*.flac | sort -n")
do
    name=$(basename "$file" .flac)
    directory=$(dirname "$file")
    echo ffmpeg -i "$file" "$directory"/"$name".wav
    #ffmpeg -i $file $dir/$name.wav
done

# Changing transcript
touch tempfile
cat $transFile | awk '{gsub("([0-9]+-[0-9]+-[0-9]+)","UTTERENCE_ID",$1)}1' | cat> tempfile


# A counter variable for selecting line from transcript
export counter=1

for i in $(find "${wavDir}/" -iname "*.wav" -o -iname "*.flac" | sort -n);
do
        temp=`echo $i | rev | cut -d"." -f2 | cut -d"/" -f1 | rev`;
        printf "Filename is %s wav \n" "$temp"
        export temp
        touch logs/$temp.log

        #echo $temp
        sed -n ${counter}p tempfile > $outFile
        cat $outFile
        if [ $counter -eq 2 ];
        then
                break;
        #       ((++counter));
        #       continue;
        fi

        ## Uncomment for online mode
        #bash online_computation.sh $outFile

        printf "Generating alignments for %s \n" "$temp"
         bash $PWD/run1File.sh $i $outDir/$temp.txt #>> logs/$temp.log

        printf "Generating posteriors for %s \n" "$temp"
        ./run1File_posterior.sh $i $currPWD/posterior/${temp}_posterior_infile.ark $wavDir $transFile $outFile

        $DIR/src/bin/post-to-tacc --binary=false $dir/final.mdl "ark:$DIR/src/bin/ali-to-post ark:$dir/ali/${temp}_ali ark:- |" "${temp}.tacc"

        $DIR/src/bin/prob-to-post ark:$currPWD/wavlib/lab/posteriors/${temp}_posterior_infile.ark ark:- |
                $DIR/src/bin/post-to-pdf-post $dir/final.mdl ark:- ark:- |
               $DIR/src/bin/post-to-phone-post --transition-id-counts="${temp}.tacc" $dir/final.mdl ark:-  "ark,t:$currPWD/wavlib/lab/posteriors/${temp}_phone_posteriors.ark"
        rm -rf $dir/ali/*
        rm -f ${temp}.tacc


        printf "Calculating Goodness of Pronounciation scores for %s \n" "$temp"
        mkdir -p gop
        cd Goodness-of-Pronounication/

        python3 prop_gop_eqn.py $currPWD/wavlib/lab/posteriors/${temp}_posterior_infile.ark $currPWD/wavlib/lab/${temp}_alignment_infile.txt $currPWD/gop/${temp}_gop.txt

        #rm -f trans_vocab.txt W   #Online mode 
        #rm -f file_lexicon.txt W
        #rm -f $libri_path/not_both1.txt
        #rm -rf wavlib/data/local/dict/online_dict/* W
        #rm -rf wavlib/data/lang_onlin/*
        #sudo rm -f $dir/phones.txt

        cd ..
        ((++counter))
done




echo "DONE"

