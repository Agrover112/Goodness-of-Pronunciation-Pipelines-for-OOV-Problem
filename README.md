
# Goodness of Pronounication Workflow

## Files required for copmputation
- run1File.sh : Computes Forced Alignments.
- run1File_posterior.sh : Computation of Acoustic model Posterior Probabilities.
- runAllFiles.sh : Calls necessary files for computation of posteriors and alignment ,GoP computation.
- online_computation.sh: Responsible for the Online/Hybrid pipelne of GoP computation.
- Goodness-of-pronounciation/prop_gop_eqn.py : Contains Python code which calculates GoP scores using posterior and alignment inputs. (Refer to comments in my fork for detailed understanding)

## Utils:

- get_ctm.sh : Get the phone level conversation time mapping files
- get_word_ctm.sh: Get the word level conversation time mapping files.
- get_time.sh : Get the times for ctm files. 
- collect_transcripts.sh : Collect and place transcripts from sub-dirs to one file.
- find_oov.sh : A file to find the OOV occurences from 2 databases.
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
