
args <- commandArgs(TRUE)
PROTEIN_NAME <- args[1]
INPUTDIR <- args[2]
OUTPUTDIR <- args[3]
library(ape)

message("Processing for ", PROTEIN_NAME)


X <- read.dna(pipe(paste0("muscle -in ", INPUTDIR,"/", PROTEIN_NAME,".fa 2>/dev/null | awk -f src/fastajoinlines | bash src/fasta_homo_puller.sh")), format="fasta")

FILE_NAME <- file.path(OUTPUTDIR, paste0(PROTEIN_NAME,".phy"))
message("Processing for ", PROTEIN_NAME, "and saving at ", FILE_NAME)
write.dna(X,format="interleaved",file=FILE_NAME)
