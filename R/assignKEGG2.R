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
  data <- input %>%
    getBlastTable

  stats <- list(nseqs = list(total = NULL,
                             KO = NULL,
                             pathways = NULL,
                             modules = NULL),
                pathways = NULL,
                modules = NULL)

  stats[["nseqs"]][["total"]] <- data %>%
    pull(sequence) %>%
    unique %>%
    length

  minpath <- list(run = FALSE)

  # Assign KOs
  data <- data %>%
    rename(KO = target) %>%
    left_join(.KO00000, by = "KO")

  if (input@e_value %>% length > 0) {
    data <- data %>%
      select(sequence, e_value, KO, gene)
  }
  else {
    data <- data %>%
      select(sequence, KO, gene)
  }

  stats[["nseqs"]][["KO"]] <- data %>%
    filter(KO != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  # Assign pathways
  data <- data %>%
    left_join(.KO00001 %>% select(KO, level3), by = "KO") %>%
    rename(pathway = level3)

  stats[["nseqs"]][["pathways"]] <- data %>%
    filter(pathway != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  stats[["pathways"]] <- data %>%
    filter(pathway != "") %>%
    pull(pathway) %>%
    unique %>%
    length

  # Assign modules
  data <- data %>%
    left_join(.KO00002 %>% select(KO, level4), by = "KO") %>%
    rename(module = level4)

  stats[["nseqs"]][["modules"]] <- data %>%
    filter(module != "") %>%
    pull(sequence) %>%
    unique %>%
    length

  stats[["modules"]] <- data %>%
    filter(module != "") %>%
    pull(module) %>%
    unique %>%
    length

  # Return results
  data <- data %>%
    arrange(sequence, KO)

  e_values <- data %>%
    pull(e_value)

  data <- data %>%
    select(-e_value) %>%
    group_by(KO, gene, pathway, module) %>%
    mutate(sequence = paste0(sequence, collapse = ",")) %>%
    unique %>%
    ungroup

  results <- new("ko_tbl", stats = stats, minpath = minpath, data = data, e_value = e_values)

  return(results)
}
