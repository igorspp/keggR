#' filterKOtable()
#'
#' filterKOtable.
#'
#' @param input keggR KO table
#' @return A filtered keggR KO table
#' @export
#' @examples
#' filterKOtable(blast)

filterKOtable <- function (input, seqs) {
  # Check input
  if (class(input)[1] != "ko_tbl") {
    stop("input is not a keggR KO table object")
  }

  # Get KO table
  data <- input %>%
    getKOtable

  # Filter
  data <- data %>%
    filter(sequence %in% seqs)

  # Return results
  results <- new("ko_tbl", data = data)

  return(results)
}
