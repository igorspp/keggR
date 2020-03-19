#' filterKOtable()
#'
#' filterKOtable
#'
#' @param input keggR KO table
#' @return A keggR KO table
#' @export
#' @examples
#' filterKOtable(blast)

# ADD CHECK FOR ko_tbl

filterKOtable <- function(input, seqs) {
  input <- input %>%
    getKOtable

  stats <- list(nseqs = list(total = NULL,
                             KO = NULL,
                             pathways = NULL,
                             modules = NULL),
                pathways = NULL,
                modules = NULL)

  minpath <- list(run = FALSE)

  object <- input %>%
    filter(sequence %in% seqs)

  stats[["nseqs"]][["total"]] <- object %>%
    pull(sequence) %>%
    unique %>%
    length

  stats[["nseqs"]][["KO"]] <- object %>%
    filter(KO != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  stats[["nseqs"]][["pathways"]] <- object %>%
    filter(pathway != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  stats[["pathways"]] <- object %>%
    filter(pathway != "") %>%
    pull(pathway) %>%
    unique %>%
    length

  stats[["nseqs"]][["modules"]] <- object %>%
    filter(module != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  stats[["modules"]] <- object %>%
    filter(module != "") %>%
    pull(module) %>%
    unique %>%
    length

  results <- new("ko_tbl", stats = stats, minpath = minpath, data = object)

  return(results)
}
