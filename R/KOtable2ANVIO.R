#' KOtable2ANVIO()
#'
#' KOtable2ANVIO
#'
#' @param input keggR KO table
#' @return A tibble
#' @export
#' @examples
#' KOtable2ANVIO(blast)

# ADD CHECK FOR ko_tbl

KOtable2ANVIO <- function(input, source) {
  data <- input %>%
    getKOtable

  if (is.null(input@e_value)) {
    data <- data %>%
      mutate(e_value = 0)
  }

  data <- data %>%
    filter(! KO %in% NA) %>%
    mutate(source = source) %>%
    select(gene_callers_id = sequence, source, accession = KO, `function` = gene, e_value) %>%
    unique

  return(data)
}
