
args <- commandArgs(TRUE)

ref_tree <- args[1] #  Reference tree
fasta_file <- args[2]    #  fasta file
out_tree <- args[3] #  Output tree


message("------------Inputs--------------")
message("Reference tree: ", ref_tree)
message("Fasta File: ", fasta_file)
message("Output tree: ", out_tree)
message("-------------------------------")


library(ape)
tree <- read.tree(ref_tree)
align <- read.dna(fasta_file, format="fasta")
taxa <- labels(align)
pruned <- drop.tip(tree,tree$tip.label[-match(taxa, tree$tip.label)])
message("[Message] Number of tips in ", ape::Ntip(pruned))
message("[Message] Writing to ", out_tree)
write.tree(pruned,file=out_tree)
message("[Message] End!")
