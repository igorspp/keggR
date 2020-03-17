#' assignKEGG()
#'
#' assignKEGG.
#'
#' @param input keggR BLAST table
#' @return A keggR KO table
#' @export
#' @examples
#' assignKEGG(blast)

# ADD CHECK FOR blast_tbl
# ADD CHECK FOR loadKEGG()

assignKEGG <- function(input) {
  seqs <- input@data %>%
    pull(sequence)

  stats <- list(nseqs = list(total = NULL,
                             KO = NULL,
                             pathways = NULL,
                             modules = NULL),
                pathways = NULL,
                modules = NULL)

  stats[["nseqs"]][["total"]] <- seqs %>%
    unique %>%
    length

  minpath <- list(run = FALSE)

  input <- input@data %>%
    select(sequence, target)

  # Assign KOs
  object <- input %>%
    left_join(.PROKARYOTES.DAT, by = c("target" = "gene")) %>%
    left_join(.KO00000, by = "KO") %>%
    select(sequence, KO, gene)

  stats[["nseqs"]][["KO"]] <- object %>%
    filter(KO != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  # Assign pathways
  object <- object %>%
    left_join(.KO00001 %>% select(KO, level3), by = "KO") %>%
    rename(pathway = level3)

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

  # Assign modules
  object <- object %>%
    left_join(.KO00002 %>% select(KO, level4), by = "KO") %>%
    rename(module = level4)

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

  # Return results
  object <- object %>%
    group_by(KO, gene, pathway, module) %>%
    mutate(sequence = paste0(sequence, collapse = ",")) %>%
    unique %>%
    ungroup

  results <- new("ko_tbl", seqs = seqs, stats = stats, minpath = minpath, data = object)

  return(results)
}
