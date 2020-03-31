#' assignKEGG2()
#'
#' assignKEGG2.
#'
#' @param input keggR HMM table
#' @return A keggR KO table
#' @export
#' @examples
#' assignKEGG2(blast)

# ADD CHECK FOR hmm_tbl
# ADD CHECK FOR loadKEGG()

assignKEGG2 <- function(input) {
  input <- input %>%
    getBlastTable
  
  stats <- list(nseqs = list(total = NULL,
                             KO = NULL,
                             pathways = NULL,
                             modules = NULL),
                pathways = NULL,
                modules = NULL)
  
  stats[["nseqs"]][["total"]] <- input %>%
    pull(sequence) %>%
    unique %>%
    length
  
  minpath <- list(run = FALSE)
  
  # Assign KOs
  object <- input %>%
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
  
  results <- new("ko_tbl", stats = stats, minpath = minpath, data = object)
  
  return(results)
}
