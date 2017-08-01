library(tidyverse)
library(jsonlite)

parse_json_rst <- function(path) {
  tmp <- jsonlite::read_json(path)
  
  res <- list(
    "model1"=list(
      model_name=tmp[["3"]][["name"]],
      lnl=tmp[["3"]][["NEB"]][["lnL"]],
      neb=tmp[["3"]][["NEB"]][["parsed"]] %>%  bind_rows() ,
      beb=tmp[["3"]][["BEB"]][["parsed"]] %>% bind_rows(),
      dnds=tmp[["3"]][["dnds_info"]][["raw"]] %>% 
        read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,number_of_classes))))
    ),
    "model2"=list(
      model_name=tmp[["4"]][["name"]],
      lnl=tmp[["4"]][["NEB"]][["lnL"]],
      neb=tmp[["4"]][["NEB"]][["parsed"]] %>%  bind_rows() %>% select(pos, aa, class, w_bar, everything()),
      beb=tmp[["4"]][["BEB"]][["parsed"]] %>% bind_rows() %>% select(pos, aa, class, w_bar, sd, everything()),
      dnds=tmp[["4"]][["dnds_info"]][["raw"]] %>% 
        read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,as.numeric(tmp[["4"]][["NEB"]][["number_of_classes"]])))))
    ), 
    "model7"=list(
      model_name=tmp[["5"]][["name"]],
      lnl=tmp[["5"]][["NEB"]][["lnL"]],
      neb=tmp[["5"]][["NEB"]][["parsed"]] %>%  bind_rows() %>% select(pos, aa, class, w_bar, everything()),
      beb=tmp[["5"]][["BEB"]][["parsed"]] %>% bind_rows(),
      dnds=tmp[["5"]][["dnds_info"]][["raw"]] %>% 
        read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,as.numeric(tmp[["5"]][["NEB"]][["number_of_classes"]])))))
    ),
    "model8"= list(
      model_name=tmp[["6"]][["name"]],
      lnl=tmp[["6"]][["NEB"]][["lnL"]],
      neb=tmp[["6"]][["NEB"]][["parsed"]] %>%  bind_rows() %>% select(pos, aa, class, w_bar, everything()),
      beb=tmp[["6"]][["BEB"]][["parsed"]] %>% bind_rows() %>% select(pos, aa, class, w_bar, sd, everything()),
      dnds=tmp[["6"]][["dnds_info"]][["raw"]] %>% 
        read_table(skip=1, col_names = c("p1", paste0("prob", seq(1,as.numeric(tmp[["6"]][["NEB"]][["number_of_classes"]])))))
    )
  )
  
  res
    
}

#parse_json_rst("C:/Users/Insight/Dropbox/Columbia/Research/pamler/assets/tmp.json")
