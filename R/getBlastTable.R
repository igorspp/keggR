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

getBlastTable <- function(object) {
  object <- object@data %>%
    separate_rows(sequence, sep = ",") %>%
    as_tibble

  return(object)
}
