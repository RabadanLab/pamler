#' Return a list of characters representing each fasta record
parse_fasta__ <- function(fasta_lines) {

  record_index <- cumsum(grepl(">", fasta_lines))
  
  # split
  res <- split(fasta_lines, record_index) 	
 
  # Get the id for each fasta record 
  id <- lapply(res, function(x) gsub(">", "", x[1]))

  # Get the sequence  
  seq <- lapply(res, function(x) {
    # Turn a vector into a fasta character
    paste0(x[2:length(x)], collapse="")
  })
  seq <- setNames(seq, id)
  
  seq
}

#' Return fasta list 
#' 
read_fasta <- function(path, by_char=FALSE) {
  parsed <- parse_fasta__(readLines(path))

  if(by_char) {
    parsed <- lapply(parsed, function(x) strsplit(x,"")[[1]])
  }

  return(parsed)
}

test_in <- c(
  ">test1",
  "aaa",
  "aaa",
  ">test2",
  "bbb",
  "bbb"
  )

test_want <- list(test1="aaaaaa", test2="bbbbbb")

test_out <- parse_fasta__(test_in)

#testthat::expect_equal(test_out, test_want)

GENETIC_CODE <- structure(c("F", "F", "L", "L", "S", "S", "S", "S", "Y", "Y", 
"*", "*", "C", "C", "*", "W", "L", "L", "L", "L", "P", "P", "P", 
"P", "H", "H", "Q", "Q", "R", "R", "R", "R", "I", "I", "I", "M", 
"T", "T", "T", "T", "N", "N", "K", "K", "S", "S", "R", "R", "V", 
"V", "V", "V", "A", "A", "A", "A", "D", "D", "E", "E", "G", "G", 
"G", "G"), .Names = c("TTT", "TTC", "TTA", "TTG", "TCT", "TCC", 
"TCA", "TCG", "TAT", "TAC", "TAA", "TAG", "TGT", "TGC", "TGA", 
"TGG", "CTT", "CTC", "CTA", "CTG", "CCT", "CCC", "CCA", "CCG", 
"CAT", "CAC", "CAA", "CAG", "CGT", "CGC", "CGA", "CGG", "ATT", 
"ATC", "ATA", "ATG", "ACT", "ACC", "ACA", "ACG", "AAT", "AAC", 
"AAA", "AAG", "AGT", "AGC", "AGA", "AGG", "GTT", "GTC", "GTA", 
"GTG", "GCT", "GCC", "GCA", "GCG", "GAT", "GAC", "GAA", "GAG", 
"GGT", "GGC", "GGA", "GGG"))

my_translate <- function(my_input, frame=1, direction="forward") {
  if(frame!=1) {
    stop("Currently only frame 1 is supported")
  }
  if(direction!="forward") {
    stop("Currently only forward direction is supported")
  }
  seqlen <- length(my_input)
  aa_len <- seqlen/3
  aa_vec <- rep(NA, aa_len)

  # loop 
  for(i in seq_along(aa_vec)) {
    nuc_start <- (i*3) - 2
    token <- paste0(my_input[nuc_start:(nuc_start+2)], collapse = "")

    aa <- GENETIC_CODE[token]
  
    if(is.na(aa)) {
      aa <- "X"
    }

    aa_vec[i] <- aa

  }
  aa_vec
}

#testthat::expect_equal(my_translate(c("A", "T", "G")), "M")
#testthat::expect_equal(my_translate(c("A", "T", "-")), "X")
#testthat::expect_equal(my_translate(rep(c("A", "T", "G"), 3)), c("M","M","M"))
