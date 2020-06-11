#' KOtable2ANVIO()
#'
#' KOtable2ANVIO.
#'
#' @param input keggR KO table
#' @return A tibble
#' @export
#' @examples
#' KOtable2ANVIO(KOtable)

KOtable2ANVIO <- function(input, source) {
  # Check input
  if (class(input)[1] != "ko_tbl") {
    stop("input is not a keggR KO table object")
  }

  # Get KO table
  data <- input %>%
    getKOtable

  data <- data %>%
    filter(! KO %in% NA) %>%
    mutate(source = source) %>%
    select(gene_callers_id = sequence, source, accession = KO, `function` = gene, e_value = evalue) %>%
    unique

  return(data)
}
