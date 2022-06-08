
# Goodness of Pronounication Workflow

Files required for copmputation
- run1File.sh : Is responsible for forced alignment
- run1File_posteriors.sh : Is responsible for computation of Acoustic model Posterior Probabilities
- runAllFiles.sh : Calls necessary files for computation of posteriors and alignment ,GoP computation.
- Goodness-of-pronounciation/\* : Contains Python code which calculates GoP scores using posterior and alignment inputs.

Utils:

- get_ctm.sh : Get the conversation time mapping files
- get_time.sh : Get the times for ctm files. 
           
```
  ┌────────────────────┐
  │                    │
  │                    │
  │     Librispeech    │
  │     Full Corpus    ├─────Pretrained──Neural-Net────┐
  │                    │                               │
  │                    │                               │
  │                    │                               │
  └────────────────────┘                               │
                                                       │               ┌─────────┐
                                                       │               │         │
                                                       │               │         │
                                                       │               │         │
       ┌──────────────────Audio────────────────────────┼───────────────►Forced   │
       │                                               │               │Alignment│
       │                                               │               │         │
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
               ┌──►│           ├─┐ └────────────┬─┘            │       │           │       │
┌───────────┐  │   └───────────┘ │              │              │       │           │       │
│           │  │                 │           Features          └──────►│           │       │
│           ├──┘                 │              │                      │           │       │
│ Transcript│                    │              └─────────────────────►│ Posteriors│       │
│           │                    │                                     │  P(p|o)   │       │
│           │                    │                                     │           ├───────┘
└───────────┘                    │                                     │           │
                                 └───Transccripts──────────────────────►           │
                                                                       │           │
                                                                       │           │
                                                                       │           │
                                                                       └───────────┘
```
