
get_llk_line_<- function(path) {
  raw_h0 <- readLines(path)
  llk_line_raw <- raw_h0[grepl("^lnL", raw_h0)]
  num_params <- as.numeric(gsub(".*np:\\s*(\\d+).*","\\1", llk_line_raw))
  llk <- as.numeric(gsub(".*\\):\\s*(\\S+)s*.*","\\1", llk_line_raw))

  list(num_params=num_params, llk=llk)  
}

args <- commandArgs(TRUE)
h0 <- args[1] # "assets/A1BG_H0.mlc"
ha <- args[2] # "assets/A1BG_HA.mlc"

h0 <- get_llk_line_(h0)
ha <- get_llk_line_(ha)

pval <- pchisq(q = 2 * (ha[["llk"]] - h0[["llk"]]), df =  ha[["num_params"]] -  h0[["num_params"]],lower.tail = FALSE)

cat(pval, sep="\n")
