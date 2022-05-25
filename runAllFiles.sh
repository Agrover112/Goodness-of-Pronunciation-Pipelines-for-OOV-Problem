### First time, run the run.sh by replacing your trascriptions in the data/allTrans.txt and your dictionary in the data/local/dict/mySrcDict.
## Update wavDir accordingly.
 set -e
wavDir=$1;
transFile=$2 #update this file with your trascriptions file
outFile=$3; 
outDir=$4; # update this variable with your destination folder
currPWD=$PWD
mkdir -p $outDir
 
export DIR="/home/chiranjeevi/kaldi";
export DIR1b=$PWD"/wavlib/exp";
#export DIR1b=$PWD/"exp"
export DIR3b=$PWD"/wavlib/data"
#export DIR3b=$PWD"/data"
#export lang=$DIR3b"/lang"
export lang=$PWD"/wavlib/data/langer"
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
counter=1

for i in $(find "${wavDir}/" -iname "*.wav" -o -iname "*.flac" | sort -n); 
do
	temp=`echo $i | rev | cut -d"." -f2 | cut -d"/" -f1 | rev`;
	printf "Filename is %s wav \n" "$temp"
	export temp
	touch logs/$temp.log

	#echo $temp
	sed -n ${counter}p tempfile > $outFile
	cat $outFile
	
	if [ $counter -eq 1 ];
	then
		((++counter));
		continue;
	fi
	printf "Generating alignments for %s \n" "$temp"
	bash $PWD/run1File.sh $i $outDir/$temp.txt #>> logs/$temp.log 
	
	printf "Generating posteriors for %s \n" "$temp"
	./run1File_posterior.sh $i $currPWD/posterior/${temp}_posterior_infile.ark $wavDir $transFile $outFile 

	printf "Calculating Goodness of Pronounciation scores for %s \n" "$temp"
	mkdir -p gop
	cd Goodness-of-Pronounication/

	python3 prop_gop_eqn.py $currPWD/wavlib/lab/posteriors/${temp}_posterior_infile.ark $currPWD/wavlib/lab/${temp}_alignment_infile.txt $currPWD/gop/${temp}_gop.txt
	cd ..
	((++counter))
done







#echo "UTTERENCE_ID" `cat $transFile | grep "\b"$temp" " | cut -d" " -f2- |sed "s/ (/=/g" | cut -d"=" -f1 | sed "s/) /=/g" | cut -d"=" -f2- | sed "s/'/XXXXX/g" | tr '[:punct:]' ' ' | tr -s " " | sed "s/XXXXX/'/g" | sed "s/ '/ /g" | tr '[A-Z]' '[a-z]'` > $outFile
#cat $outFile
#awk '{gsub("([0-9]+-[0-9]+-[0-9]+)","UTTERANCE_ID",$1)}1' $transFile | tr '[A-Z]' '[a-z]' | cat >$outFile
#cat $transFile | tr [A-Z] [a-z]  | awk '{gsub("([0-9]+-[0-9]+-[0-9]+)","UTTERENCE_ID",$1)}1' | cat>$outFile

