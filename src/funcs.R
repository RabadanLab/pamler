lookup_table <- function(aa_query, aa_subject) {

  # construct a look up table
  index_lookup <- rep(NA, length(aa_query))
  
  j <- 1
  
  for(i in seq_along(index_lookup)) {

    query_current <- aa_query[i]
    subject_current <- aa_subject[j]
    
    if(grepl("[X-]", query_current)) {
      next
    }
    while(grepl("[X-]", subject_current)) {
      j <- j + 1
      subject_current <- aa_subject[j]
      
      if(is.na(subject_current)) {
        subject_current <- "END"
      }
    }
    
    if(query_current == subject_current) {
      # if matches, record
      index_lookup[i] <- j
      j <- j + 1
    } else {
        stop(query_current, " at position ", i, " and " , subject_current, " at position ", j, " do not match!")
    }

    }
    index_lookup

  }