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

KOtable2ANVIO <- function(input) {
  input <- input %>%
    getKOtable

  object <- input %>%
    filter(! KO %in% NA) %>%
    mutate(source = "KEGG") %>%
    mutate(e_value = 0) %>%
    select(gene_callers_id = sequence, source, accession = KO, `function` = gene, e_value) %>%
    unique

  return(object)
}
