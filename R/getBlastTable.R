#' getBlastTable()
#'
#' getBlastTable.
#'
#' @param input keggR BLAST table
#' @return A tibble
#' @export
#' @examples
#' getBlastTable(blast)

# ADD CHECK FOR blast_tbl

getBlastTable <- function(input) {
  data <- input@data %>%
    separate_rows(sequence, sep = ",") %>%
    arrange(sequence, target)

  if (input@e_value %>% length > 0) {
    data <- data %>%
      mutate(e_value = input@e_value)
  }

  return(data)
}
