#!/bin/bash
# Ankit @agrover112 2022
# Apache 2.0



db1="../librispeech/s5/data/local/dict_nosp/cmudict.0.7a.plain"
db2="../librispeech/s5/data/local/lm/librispeech-vocab.txt"



 cat $PWD"/wavlib/data/split1/1/text" | tr "\t" " " | tr -s " " | cut -d" " -f2- > text_temp


 # Store OOV words in this file
 bash find_oov.sh  $db1 $db2 text_temp


 # Get the OOV and set to 1 if OOV is present
 oov=0;
 if [ -s not_both1.txt ]; then
        # The file is not-empty and has OOV words .
        #rm -f not_both1.txt;
        #rm -f not_db1.txt;
        oov=1;
        # The file is empty.
fi

if [ $oov -eq 1 ];then
        # Extend the vocabulary
        cat not_both1.txt | cat - $db2 | sort | uniq > librispeech-vocab-extended.txt
fi
