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

readHMM <- function(file, e_value = FALSE) {
  data <-  read_delim(file,
                      delim = "\t",
                      col_names = c("sequence", "target", "e_value", "score"),
                      col_types = cols_only(sequence = col_character(), target = col_character(), e_value = col_double())) %>%
    arrange(sequence, target)

  e_values <- data %>%
    pull(e_value)

  data <- data %>%
    select(-e_value) %>%
    group_by(target) %>%
    mutate(sequence = paste0(sequence, collapse = ",")) %>%
    unique %>%
    ungroup

  if (isTRUE(e_value)) {
    results <- new("blast_tbl", data = data, e_value = e_values)
  } else {
    results <- new("blast_tbl", data = data)
  }

  return(results)
}
