#' readHMM()
#'
#' Read HMM results.
#'
#' @param input HMM file
#' @return A keggR HMM table
#' @export
#' @examples
#' readHMM("/examples/input_data.txt")

# ADD CHECK TO NOT ALLOW COMMAS IN SEQUENCE NAME

readHMM <- function(file) {
  object <-  read_delim(file,
                        delim = "\t",
                        col_names = c("sequence", "KO", "evalue", "score"),
                        col_types = cols_only(sequence = col_character(), KO = col_character())) %>%
    group_by(KO) %>%
    mutate(sequence = paste0(sequence, collapse = ",")) %>%
    unique %>%
    ungroup
  
  results <- new("blast_tbl", data = object)
  
  return(results)
}

