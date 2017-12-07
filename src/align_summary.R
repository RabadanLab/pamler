source("src/funcs_seq.R")
args <- commandArgs(TRUE)
my_alignment <- args[1]

count_gaps <- function(x) {
  if(is.null(x)) {
  	return(0)
  }
  num_gaps <- 0 
  # Convert to binary vector
  x_class <- grepl("-", x)

  # RLE will reduce the consecurive elements
  rle_res <- rle(x_class)
  sum(rle_res$values)
}

# test_in <- c("-", "-", "X", "-", "-")
# test_out <- count_gaps(test_in) 
# test_want <- 2L
# testthat::expect_equal(test_out, test_want)

# test_in <- NULL
# test_out <- count_gaps(test_in) 
# test_want <- 0L
# testthat::expect_equal(test_out, test_want)

# test_in <- NA
# test_out <- count_gaps(test_in) 
# test_want <- 0L
# testthat::expect_equal(test_out, test_want)

# test_in <- c("-")
# test_out <- count_gaps(test_in) 
# test_want <- 1L
# testthat::expect_equal(test_out, test_want)

# test_in <- c("-", "-")
# test_out <- count_gaps(test_in) 
# test_want <- 1L
# testthat::expect_equal(test_out, test_want)

# test_in <- c("X", "-", "-")
# test_out <- count_gaps(test_in) 
# test_want <- 1L
# testthat::expect_equal(test_out, test_want)

summarize_alignment <- function(my_al) {
  
  length_of_align <- length(my_al[[1]])
  
  stopifnot(length_of_align == length(my_al[[2]]))
  
	# Number of gaps
  num_gaps_s1 <- count_gaps(my_al[[1]])
  num_gaps_s2 <- count_gaps(my_al[[2]])
  
	# percent identity - exclude gaps
  pos_consider <- !( grepl("-", my_al[[1]]) | grepl("-", my_al[[2]]) ) 
  al_length <- sum(pos_consider)
  num_identity <- sum(my_al[[1]][pos_consider] == my_al[[2]][pos_consider])
  perc_identity <- (num_identity/al_length) * 100
	
  # query length
	# subject length
  s1_length <- sum(!grepl("-", my_al[[1]]))
  s2_length <- sum(!grepl("-", my_al[[2]]))
  
  list(
    s1_length=s1_length,
    s2_length=s2_length,
    perc_identity=perc_identity, 
    num_gaps_s1=num_gaps_s1,
    num_gaps_s2=num_gaps_s2
  )
}

my_al <- read_fasta(my_alignment, by_char=TRUE)
suppressPackageStartupMessages(suppressWarnings(library(tidyverse)))
as_tibble(summarize_alignment(my_al)) %>% 
  gather() %>% 
  format_tsv() %>% 
  cat()
