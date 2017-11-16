# Descriptions
# This script returns a table from parsed JSON file
# 
# Usage
#   - Rscript src/rst2table.R <JSON_PATH> pvalue # returns a pvalue
#   - Rscirpt src/rst2table.R <JSON_PATH> site_dnds # returns a site-by-site dnds table for a winning model ( model7 vs model 8, depending on the p value)
#   - Rscirpt src/rst2table.R <JSON_PATH> mean_dnds # returns a mean dnds for a winning model using NEB table ( model7 vs model 8, depending on the p value)
#   - Rscript src/rst2table.R <JSON_PATH> pos_beb # returns a significant, positive selected site from BEB table for a winning model; returns 0 if model 7 won

# this script depends on
# - 1. JSON file that was processed via rst2json.pl
# - 2. src/json2r.R
#
source("src/json2r.R")

get_model_item <- function(model_name, item_name, format="tsv") {
  df <- my_json[[model_name]][[item_name]] 
  if(format=="tsv") {
    df %>% 
    format_tsv() %>% 
    cat()
  }
  invisible(df)
}

args <- commandArgs(TRUE)
JSON_PATH <- args[1]
ITEM <- args[2]

if(is.na(JSON_PATH)) {
  stop("Please provide JSON FILE!")
}

if(is.na(ITEM)) {
  stop("Please provide either 'pval', 'mean_dnds', 'site_dnds', or 'pos_beb' !")
}
my_json <- parse_json_rst(JSON_PATH)

llk_h0 <- as.numeric(my_json[["model7"]][["lnl"]])
llk_ha <- as.numeric(my_json[["model8"]][["lnl"]])


pvalue <- pchisq(q = 2 * (llk_ha - llk_h0), df = 1,lower.tail = FALSE)

if(ITEM == "pval" | ITEM == "pvalue" | ITEM == "p") {
  cat(pvalue, sep="\n")
  quit()
}

WINNING_MODEL <- if(pvalue < 0.05) my_json[["model8"]] else my_json[["model7"]]

if(ITEM == "mean_dnds") {
  cat(mean(WINNING_MODEL[["neb"]][["w_bar"]]), sep="\n")
  quit()
}

if(ITEM == "site_dnds") {
  WINNING_MODEL[["neb"]] %>% 
    select(pos, aa, w_bar) %>% 
    format_tsv() %>% 
    cat()
}

if(ITEM == "pos_beb") {
  if ( pvalue < 0.05 ) {
    WINNING_MODEL[["beb_pos_sel"]] %>% 
      filter(grepl("\\*", prob_w_gt_1)) %>% 
      select(pos, aa, prob_w_gt_1, mean_w) %>% 
      format_tsv() %>% 
      cat()
  } else {
    cat(0, sep="\n")
  }
}

