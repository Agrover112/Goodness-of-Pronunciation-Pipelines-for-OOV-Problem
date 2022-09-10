
# Goodness of Pronounication Workflow

Files required for copmputation
- run1File.sh : Is responsible for forced alignment
- run1File_posteriors.sh : Is responsible for computation of Acoustic model Posterior Probabilities
- runAllFiles.sh : Calls necessary files for computation of posteriors and alignment ,GoP computation.
- online_computation.sh: Responsible for the Online/Hybrid pipelne of GoP computation.
- Goodness-of-pronounciation/\* : Contains Python code which calculates GoP scores using posterior and alignment inputs.

Utils:

- get_ctm.sh : Get the phone level conversation time mapping files
- get_word_ctm.sh: Get the word level conversation time mapping files.
- get_time.sh : Get the times for ctm files. 
- collect_transcripts.sh : Collect and place transcripts from sub-dirs to one file.
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
