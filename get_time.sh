#!/bin/bash
#max=`cat /tmp/e |  perl -nle '$sum += $_ } END { print $sum'`
file=$1;
#max=`wc -l $file | sed "s:/tmp/e::g"`

time=($(cut -d" " -f1 $file));
#echo $time
max=`echo ${#time[@]}`;
#echo $max
cat /dev/null > time_stamp
rm -rf time_stamp
for (( i=0; i <= $max; i++ ))
do

	if [ $i == 0 ]
	then
#   		echo 0 ${time[$i]} ${time[$i]};
   		echo 0 ${time[$i]};
		val1=${time[$i]};

	elif [ $i == 1 ]
        then
                #echo $val1 ${time[$i]} `expr $val1 + ${time[$i]}`;
                echo `echo 0.01 \* $(($val1 - 1)) | bc` `echo 0.01 \* $(($val1 + ${time[$i]} - 1)) | bc`;
        	val2=`expr $val1 + ${time[$i]}`;
	elif [ $i -lt `expr $max - 1` ]
	then
   		#echo $val2 ${time[$i]} `expr $val2 + ${time[$i]}`;
   		echo `echo 0.01 \* $(($val2 - 1)) | bc` `echo 0.01 \* $(($val2 + ${time[$i]} - 1)) | bc`;
		val2=`expr $val2 + ${time[$i]}`;
	elif [ $i == `expr $max - 1` ]
	then
		#echo $val2 ${time[$i]} `expr $val2 + ${time[$i]} + 2`;
		echo `echo 0.01 \* $(($val2 - 1)) | bc` `echo 0.01 \* $(($val2 + ${time[$i]} - 1)) | bc`;
	
	else
		val1=0;val2=0;
	fi

done >> time_stamp;
#cat time_stamp
#echo ${time[`expr $max - 1`]}
