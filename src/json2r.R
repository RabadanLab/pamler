suppressWarnings(suppressPackageStartupMessages(library(tidyverse)))
suppressWarnings(suppressPackageStartupMessages(library(jsonlite)))

parse_neb__ <- function(neb) {
  neb %>%  
    bind_rows() %>% 
    select(pos, aa, class, w_bar, everything()) %>% 
    mutate_at(as.numeric, .vars = 4:ncol(.))
}
parse_json_rst <- function(path) {
  tmp <- jsonlite::read_json(path)
  
  names_of_fields <- map(tmp, "name")
  MODEL7_POS <- grep("7: beta", names_of_fields)
  MODEL8_POS <- grep("^8: beta", names_of_fields)
  res <- list(
    # "model1"=list(
    #   model_name=tmp[["3"]][["name"]],
    #   lnl=tmp[["3"]][["NEB"]][["lnL"]],
    #   neb=tmp[["3"]][["NEB"]][["parsed"]] %>%  bind_rows() ,
    #   beb=tmp[["3"]][["BEB"]][["parsed"]] %>% bind_rows(),
    #   dnds=tmp[["3"]][["dnds_info"]][["raw"]] %>% 
    #     read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,as.numeric(tmp[["3"]][["NEB"]][["number_of_classes"]])))))
    # ),
    "model7"=list(
      model_name=tmp[[MODEL7_POS]][["name"]],
      lnl=tmp[[MODEL7_POS]][["NEB"]][["lnL"]],
      neb=parse_neb__(tmp[[MODEL7_POS]][["NEB"]][["parsed"]]) ,
      #beb=tmp[[MODEL7_POS]][["BEB"]][["parsed"]] %>% bind_rows() %>% select(pos, aa, class, w_bar, sd, everything()),
      dnds=tmp[[MODEL7_POS]][["dnds_info"]][["raw"]] %>% 
        read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,as.numeric(tmp[[MODEL7_POS]][["NEB"]][["number_of_classes"]])))))
    ), 
    "model8"=list(
      model_name=tmp[[MODEL8_POS]][["name"]],
      lnl=tmp[[MODEL8_POS]][["NEB"]][["lnL"]],
      neb=parse_neb__(tmp[[MODEL8_POS]][["NEB"]][["parsed"]]), 
      beb=parse_neb__(tmp[[MODEL8_POS]][["BEB"]][["parsed"]]),
      beb_pos_sel=tmp[[MODEL8_POS]][["BEB"]][["POST_SELECTED"]] %>% bind_rows(),
      dnds=tmp[[MODEL8_POS]][["dnds_info"]][["raw"]] %>% 
        read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,as.numeric(tmp[[MODEL8_POS]][["NEB"]][["number_of_classes"]])))))
    ) 
  )
  
  res
    
}

# parse_json_rst("C:/Users/Kernyu Park/Google Drive/Columbia/GSAS/Research/17_S/QUEST/json_rst")

