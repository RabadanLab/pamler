library(ape)

args <- commandArgs(TRUE)
my_fasta_path <- args[1]
output_aa <- args[2]

if(is.na(my_fasta_path) | is.na(output_aa)) {
    stop("nuc2aa.R <fasta_path> <output aa fasta>")
}

if(!file.exists(my_fasta_path)) {
    stop(my_fasta_path, " doesn't exist")
}

my_fasta <- read.FASTA(my_fasta_path)
my_aa <- trans(my_fasta, code = 1, codonstart = 1)

write.dna(my_aa, file=output_aa, format="fasta")

