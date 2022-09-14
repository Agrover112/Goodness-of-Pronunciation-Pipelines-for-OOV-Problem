
# Goodness of Pronunciation Pipelines for OOV Problem 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7078841.svg)](https://doi.org/10.5281/zenodo.7078841)

A proposed pipeline for GoP computation solving OOV problem at Testing time using Vocab/Lexicon expansion techniques.
We also provide utilities for extracting the Phoneme posteriors , Word boundaries(alignments), using GoP scores as vectors.
The detailed explanation of the pipelines and methods are described in this [report](https://arxiv.org/abs/2209.03787).
## Main Files
- `run1File.sh` : Computes Forced Alignments.
- `run1File_posterior.sh` : Computation of Acoustic model Posterior Probabilities.
- `runAllFiles.sh : `Calls necessary files for computation of posteriors and alignment ,GoP computation.
- `online_computation.sh:` Responsible for the Online/Hybrid pipelne of GoP computation.
- `conf/: ` Configuration files for MFCC, i-vector extractors,etc.
- `get_failed_entries.sh` : File generates a Lexicon from a text file or dir of text files, along with list of failed entries if any.
- `Goodness-of-pronounciation/prop_gop_eqn.py` : Contains Python code which calculates GoP scores using posterior and alignment inputs. (Refer to comments in my fork for detailed understanding).

The entire `data` and `exp` and `lab` folders can be found [here](https://drive.google.com/drive/folders/1-q1a-jv-dhJdn8KTRqWmxW3wF0e-V0sT?usp=sharing).

## Utils:

- `get_ctm.sh` : Get the phone level conversation time mapping files
- `get_word_ctm.sh`: Get the word level conversation time mapping files.
- `get_time.sh` : Get the times for ctm files. 
- `collect_transcripts.sh` : Collect and place transcripts from sub-dirs to one file.
- `find_oov.sh `: A file to find the OOV occurences from 2 databases.
- `append_vocab.sh` : Append OOV lexicon entries to original Lexicon
- `temp_q.sh` : File for pre-processing text.
- `dict.sh`: A modified utils/prepare_dict.sh for Lexicon generation


Entry-point for running the entire pipeline
```bash
./get_acoustic_metrics.sh wav_file_dir_path transcript_file_dir_path output_folder path 
```

## Outputs:

- `gop/`: Contains GoP scored outputs and phone level posteriors (ID_gop_phone_posteriors.txt).
- `lab/posteriors/`: Contains ID_posterior_infile.ark from `nnet-compute` and ID_phone_posteriors.ark are posteriors in different format than gop  posteriors.
- `lab/`: Contains Forced Alignments outputs(phone level and word level .ctm files) ID_word_.ctm and ID_alignment_infile.txt


![image](https://user-images.githubusercontent.com/42321810/189543094-bb386620-1208-4544-8330-3588dfcf76cf.png)

