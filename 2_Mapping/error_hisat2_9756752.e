Settings:
  Output files: "GRCh38.genome.*.ht2"
  Line rate: 6 (line is 64 bytes)
  Lines per side: 1 (side is 64 bytes)
  Offset rate: 4 (one in 16)
  FTable chars: 10
  Strings: unpacked
  Local offset rate: 3 (one in 8)
  Local fTable chars: 6
  Local sequence length: 57344
  Local sequence overlap between two consecutive indexes: 1024
  Endianness: little
  Actual local endianness: little
  Sanity checking: disabled
  Assertions: disabled
  Random seed: 0
  Sizeofs: void*:8, int:4, long:8, size_t:8
Input files DNA, FASTA:
  /data/courses/rnaseq_course/lncRNAs/Project1/users/srasch/RawData/hisat2_index/GRCh38.genome.fa
Reading reference sizes
  Time reading reference sizes: 00:00:16
Calculating joined length
Writing header
Reserving space for joined string
Joining reference sequences
  Time to join reference sequences: 00:00:12
  Time to read SNPs and splice sites: 00:00:00
Using parameters --bmax 35734170 --dcv 1024
  Doing ahead-of-time memory usage test
  Passed!  Constructing with these parameters: --bmax 35734170 --dcv 1024
Constructing suffix-array element generator
Converting suffix-array elements to index image
Allocating ftab, absorbFtab
Entering GFM loop
Exited GFM loop
fchr[A]: 0
fchr[C]: 898348131
fchr[G]: 1522007053
fchr[T]: 2148410610
fchr[$]: 3049315783
Exiting GFM::buildToDisk()
Returning from initFromVector
Wrote 1020665981 bytes to primary GFM file: GRCh38.genome.1.ht2
Wrote 762328952 bytes to secondary GFM file: GRCh38.genome.2.ht2
Re-opening _in1 and _in2 as input streams
Returning from GFM constructor
Returning from initFromVector
Wrote 1342456349 bytes to primary GFM file: GRCh38.genome.5.ht2
Wrote 776249234 bytes to secondary GFM file: GRCh38.genome.6.ht2
Re-opening _in5 and _in5 as input streams
Returning from HGFM constructor
Headers:
    len: 3049315783
    gbwtLen: 3049315784
    nodes: 3049315784
    sz: 762328946
    gbwtSz: 762328947
    lineRate: 6
    offRate: 4
    offMask: 0xfffffff0
    ftabChars: 10
    eftabLen: 0
    eftabSz: 0
    ftabLen: 1048577
    ftabSz: 4194308
    offsLen: 190582237
    offsSz: 762328948
    lineSz: 64
    sideSz: 64
    sideGbwtSz: 48
    sideGbwtLen: 192
    numSides: 15881854
    numLines: 15881854
    gbwtTotLen: 1016438656
    gbwtTotSz: 1016438656
    reverse: 0
    linearFM: Yes
Total time for call to driver() for forward index: 00:19:02
