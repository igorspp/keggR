#' getBlastTable()
#'
#' Extract BLAST table from a keggR BLAST table object.
#'
#' @param input keggR BLAST table
#' @return A tibble
#' @export
#' @examples
#' getBlastTable(blast)

getBlastTable <- function(input) {
  # Check input
  if (class(input)[1] != "blast_tbl") {
    stop("input is not a keggR BLAST table object")
  }

  # De-compact data frame
  data <- input@data %>%
    separate_rows(c(sequence, evalue), sep = "!!!") %>%
    mutate(evalue = as.double(evalue))

  return(data)
}
