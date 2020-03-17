#' getKOtable()
#'
#' getKOtable.
#'
#' @param input keggR KO table
#' @return A tibble
#' @export
#' @examples
#' getKOtable(KOtable)

# ADD CHECK FOR ko_tbl

getKOtable <- function(object) {
  object <- object@data %>%
    separate_rows(sequence, sep = ",") %>%
    arrange(match(sequence, object@seqs)) %>%
    as_tibble

  return(object)
}
