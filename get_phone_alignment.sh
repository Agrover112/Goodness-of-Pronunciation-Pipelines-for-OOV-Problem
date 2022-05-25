. ./path.sh
i=$1;
phnSym=$2;
mdlFile=$3;
aliFile=$4;
fileOut=$5;
echo "hehe","$PWD"
/home/chiranjeevi/kaldi/src/bin/show-alignments $phnSym $mdlFile ark:$aliFile > tmp.a 

cat tmp.a|grep $i|head -1|sed "s/\[/\n/g" | sed "s/\]/\n/g" |sed '/^\s*$/d'|sed -e "s/[[:space:]]\+/ /g" | cat - | grep -v trn | cat - > tmp.b
cat tmp.a|grep $i|head -2|tail -1|sed '/^\s*$/d'|sed -e "s/[[:space:]]\+/ /g" | sed 's/ /\n/g'| grep -v '^$' | grep -v trn | cat - > tmp.c

paste tmp.c tmp.b | cat - > tmp.d

cat tmp.b | cut -c2- - | awk -F '[ ]' '{print NF-1}' | cat - > tmp.e

bash get_time.sh tmp.e 

j=`echo $i | sed 's/_//g'| sed 's/trn//g'`

paste time_stamp tmp.c | grep -v $i | cut -d"_" -f1 > $fileOut

#rm tmp.a tmp.b tmp.c tmp.d tmp.e

