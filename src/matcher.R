suppressWarnings(suppressPackageStartupMessages(library(tidyverse)))
source("src/funcs.R")
source("src/funcs_seq.R")

args <- commandArgs(TRUE)
#args <- c("C:/Users/Insight/Desktop/OBSCN.gapped.human", "C:/Users/Insight/Desktop/OBSCN.aligned")

# GENE_NT_GAPPED should be a fasta file obtained from mlc file
GENE_NT_GAPPED <- args[1] 
MUSCLE_ALIGNED_PEP <- args[2] 

my_seq <- read_fasta(GENE_NT_GAPPED, by_char = TRUE)[[1]]
my_seq <- my_translate(my_seq)

my_al <- read_fasta(MUSCLE_ALIGNED_PEP, by_char=TRUE)
my_aa <- my_al[["homo_sapiens"]]

lkup_1 <- lookup_table(my_seq, my_aa)

my_uniprot <- my_al[[2]]
my_uniprot_rmgap <- my_uniprot[!grepl("-", my_uniprot)]

lkup_2 <- lookup_table(my_uniprot, my_uniprot_rmgap)


tibble(codeml=1:length(my_seq)) %>% 
  mutate(uniprot=as.integer(lkup_2[lkup_1[codeml]])) %>% 
  format_tsv() %>% 
  cat()

