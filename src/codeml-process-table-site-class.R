get_site_class_tbl_<- function(path) {
  raw_h0 <- readLines(path)
  table_start_pos <- which(grepl("^site class", raw_h0))
  raw_h0[seq(table_start_pos, table_start_pos + 3, by = 1)]
  df <- read.fwf(path, widths = c(12, 12, 9, 9, 9),skip = table_start_pos,  n = 3)
  colnames(df) <-  c("site_class", "M0", "M1", "M2a", "M2b")
  df <- suppressWarnings(dplyr::mutate(df, site_class=as.character(site_class)))
  df <- suppressWarnings(dplyr::mutate(df, site_class=stringr::str_trim(site_class)))
  cat(readr::format_csv(df))
}

args <- commandArgs(TRUE)
get_site_class_tbl_(args[1])

