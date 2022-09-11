
# Goodness of Pronounication Workflow

## Main Files
- `run1File.sh` : Computes Forced Alignments.
- `run1File_posterior.sh` : Computation of Acoustic model Posterior Probabilities.
- `runAllFiles.sh : Calls` necessary files for computation of posteriors and alignment ,GoP computation.
- `online_computation.sh:` Responsible for the Online/Hybrid pipelne of GoP computation.
- `get_failed_entries.sh` : File generates a Lexicon from a text file or dir of text files, along with list of failed entries if any.
- `Goodness-of-pronounciation/prop_gop_eqn.py` : Contains Python code which calculates GoP scores using posterior and alignment inputs. (Refer to comments in my fork for detailed understanding)

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
sudo bash get_acoustic_metrics.sh
```

Outputs:

- `gop/`: Contains GoP scored outputs and phone level posteriors (ID_gop_phone_posteriors.txt).
- `lab/posteriors/`: Contains ID_posterior_infile.ark from `nnet-compute` and ID_phone_posteriors.ark are posteriors in different format than gop  posteriors.
- `lab/`: Contains Forced Alignments outputs(phone level and word level .ctm files) ID_word_.ctm and ID_alignment_infile.txt

```
                                 ┌────────────────────┐
                                 │                    │
                                 │   Automatic        ├────────────────────┐
                                 │   Lexicon          │                    │
                                 │   Generation       │                    │
                                 │                    │                    │
                                 │                    │                    │
                                 └────────────────────┘                    │
                                         ▲                                 │
  ┌────────────────────┐                 │                                 │
  │                    │                 │                                 │
  │                    │                 │                                 │
  │     Librispeech    │                 │                                 │
  │     Full Corpus    ├─────Pretrained──Neural-Net────┐                   │
  │                    │                 │             │                   │
  │                    │                 │             │                   │
  │                    │                 │             │                   │
  └────────────────────┘                 │             │                   │
                                         │             │               ┌───▼─────┐
                                         │             │               │         │
                                         │             │               │         │
                                         │             │               │         │
       ┌─────────────────────────────────┼─────────────┼───────────────►Forced   │
       │                                 │             │               │Alignment│
       │                                 │             │               │         │
       │                         ┌───Transcripts───────┼──────────────►│  Align  ├────────┐
       │                         │                     │               │  &      │        │
       │                         │                     │               │ Decode  │        │
┌──────┴───┐                     │              ┌──────┼──────────────►│         │        │         ┌──────────────┐
│          │                     │              │      │               │         │        │         │ Modified     │
│  Speech  │                     │            Features │       ┌──────►│         │        │         │              │
│  Files   ├─┐                   │              │      │       │       └─────────┘        └────────►│   GoP        │
│ waveflac │ │                   │              │      │       │                                    │              ├────────► GoP Scores
│          │ │     ┌───────────┐ │ ┌────────────┴─┐   ┌▼───────┴──┐                                 │ Formulation  │
└──────────┘ │     │           │ │ │              │   │  Acoustic │                        ┌───────►│              │
             └────►│  Cleaning ├─┴─►   Feature    │   │   Model   │                        │        │              │
                   │           │   │   Extraction │   │           │                        │        └──────────────┘
                   │           │   │              │   └────────┬──┘    ┌───────────┐       │
               ┌──►│           ├─┐ └──────▲─────┬─┘            │       │           │       │
┌───────────┐  │   └───────────┘ │        │     │              │       │           │       │
│           │  │                 │        │  Features          └──────►│           │       │
│           ├──┘                 │        │     │                      │           │       │
│ Transcript│          ┌─────────┼────────┘     └─────────────────────►│ Posteriors│       │
│           │          │         │                                     │  P(p|o)   │       │
│           │          │         │                                     │           ├───────┘
└───────────┘          │         │                                     │           │
                       │         └───Transccripts──────────────────────►           │
                       │                                               │           │
               ┌───────┴───────┐                                       │           │
               │               │                                       │           │
               │  Pre-trained  │                                       └───────────┘
               │  Diag-GMM-UBM │
               │               │
               └───────────────┘
```
