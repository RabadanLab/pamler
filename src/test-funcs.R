
source("funcs.R")
library(testthat)

test_out <- lookup_table(c("A", "B", "X", "C", "D", "E"), c("A", "B", "C", "D", "-", "E"))
expect_equal(test_out, c(1, 2, NA, 3, 4, 6) )
test_out <- lookup_table(c("A", "B", "C", "D", "-", "E"), c("A", "B", "X", "C", "D", "E"))
expect_equal(test_out, c(1, 2, 4, 5, NA, 6) )

test1_out <- lookup_table(c("X", "A", "B", "X", "C", "D", "E"), c("A", "B", "C", "D", "-", "E"))
expect_equal(test1_out, c(NA, 1, 2, NA, 3, 4, 6) )

test2_out <- lookup_table(c("A", "B", "X", "C", "D", "E", "X"), c("A", "B", "C", "D", "-", "E"))
expect_equal(test2_out, c(1, 2, NA, 3, 4, 6, NA))

expect_error(lookup_table(c("A", "B", "X", "C", "D", "S"), c("A", "B", "C", "D", "-" ,"-", "-", "-","E")))

test3_out <- lookup_table(c("A", "B", "X", "C", "D", "E"), c("A", "B", "C", "D", "-" ,"-", "-", "-","E"))
expect_equal(test3_out, c(1, 2, NA, 3, 4, 9))

test4_out <- lookup_table(c("A", "B", "X", "C", "D", "E"), c("A", "B", "C", "D", "-" ,"-", "-", "E", "-","-"))

expect_error(lookup_table(c("A", "B", "X", "C", "D", "E"), c("A", "B", "C", "D", "-" ,"-", "-", "-","-")))

