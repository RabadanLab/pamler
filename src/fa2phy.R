args <- commandArgs(TRUE)
FASTA <- args[1]
OUTPUTFILE <- args[2]
library(ape)

X <- read.dna(FASTA, format="fasta")

write.dna(X, file=OUTPUTFILE, format="sequential")

