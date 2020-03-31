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

getKOtable <- function(input) {
  data <- input@data %>%
    separate_rows(sequence, sep = ",") %>%
    arrange(sequence, KO)

  if (input@e_value %>% length > 0) {
    data <- data %>%
      mutate(e_value = input@e_value)
  }

  return(data)
}
