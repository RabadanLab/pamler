# Descriptions
# This script returns a table for a model that was appropriate for the given codeml.
# Model is selected based on likelihoods between model 7 and model 8 of the rst file.
# 
# Usage
#   - Rscript src/rst2table.R <JSON_PATH> pvalue # returns a pvalue
#   - Rscirpt src/rst2table.R <JSON_PATH> dnds # returns a dnds table for a winning model ( model7 vs model 8, depending on the p value)
#   - Rscript src/rst2table.R <JSON_PATH> neb # returns a NEB table for a winning model

# this script depends on
# - 1. JSON file that was processed via rst2json.pl
# - 2. src/json2r.R
source("src/json2r.R")

get_model_item <- function(model_name, item_name) {
  my_json[[model_name]][[item_name]] %>% 
    format_tsv() %>% 
    cat()
}

args <- commandArgs(TRUE)
JSON_PATH <- args[1]
ITEM <- args[2]

my_json <- parse_json_rst(JSON_PATH)

llk_h0 <- as.numeric(my_json[["model7"]][["lnl"]])
llk_ha <- as.numeric(my_json[["model8"]][["lnl"]])


pvalue <- pchisq(q = 2 * (llk_ha - llk_h0), df = 1,lower.tail = FALSE)

if(ITEM == "pval" | ITEM == "pvalue" | ITEM == "p") {
  cat(pvalue)
  quit()
}

if(pvalue > 0.05) {
  get_model_item("model7", ITEM, format="tsv")
} else{
  get_model_item("model8", ITEM, format="tsv")
}