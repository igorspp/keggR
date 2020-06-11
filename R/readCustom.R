#' readCustom()
#'
#' Read custom KEGG results.
#'
#' @param file Tab-delimited file
#' @param colnames Vector
#' @param evalue Double
#' @return A keggR BLAST table
#' @export
#' @examples
#' readCustom("examples/custom_input_data.txt")

readCustom <- function(file, colnames, evalue = 1) {
  EVALUE <- evalue

  # Read data
  data <-  read_delim(file, delim = "\t",
                      col_names = colnames,
                      col_types = cols_only(sequence = col_character(), KO = col_character(), evalue = col_double()))

  # Filter based on e-value
  data <- data %>%
    filter(evalue < EVALUE)

  # Compact data frame
  data <- data %>%
    group_by(KO) %>%
    mutate(sequence = paste0(sequence, collapse = "!!!")) %>%
    mutate(evalue = paste0(evalue, collapse = "!!!")) %>%
    unique %>%
    ungroup

  # Return results
  results <- new("blast_tbl", data = data)

  return(results)
}
