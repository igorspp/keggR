#' getKOtable()
#'
#' Extract KO table from a keggR KO table object.
#'
#' @param input keggR KO table
#' @return A tibble
#' @export
#' @examples
#' getKOtable(KOtable)

getKOtable <- function(input) {
  # Check input
  if (class(input)[1] != "ko_tbl") {
    stop("input is not a keggR KO table object")
  }

  # De-compact data frame
  data <- input@data %>%
    separate_rows(c(sequence, evalue), sep = "!!!")

  return(data)
}
