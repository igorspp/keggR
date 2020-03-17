#' summariseKEGG()
#'
#' summariseKEGG.
#'
#' @param input keggR KO table
#' @return A keggR summary table
#' @export
#' @examples
#' summariseKEGG(KOtable)

# ADD CHECK FOR ko_tbl
# ADD CHECK FOR loadKEGG()

summariseKEGG <- function(input) {
  minpath <- input@minpath

  input <- getKOtable(input) %>%
    select(sequence, KO, gene) %>%
    filter(KO != "") %>%
    unique

  # Pathways
  pathways <- input %>%
    left_join(.KO00001, by = "KO") %>%
    filter(level1 != "")

  if (minpath[["run"]] == TRUE) {
    pathways <- pathways %>%
      filter(level3 %in% minpath[["pathways"]][["good"]])
  }

  pathways_lvl1 <- pathways %>%
    select(sequence, level1) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  pathways_lvl2 <- pathways %>%
    select(sequence, level1, level2) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  pathways_lvl3 <- pathways %>%
    select(sequence, level1, level2, level3) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2, level3) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  pathways_lvl4 <- pathways %>%
    select(sequence, level1, level2, level3, KO, gene) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2, level3, KO, gene) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  # Modules
  modules <- input %>%
    left_join(.KO00002, by = "KO") %>%
    filter(level1 != "")

  if (minpath[["run"]] == TRUE) {
    modules <- modules %>%
      filter(level4 %in% minpath[["modules"]][["good"]])
  }

  modules_lvl1 <- modules %>%
    select(sequence, level1) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  modules_lvl2 <- modules %>%
    select(sequence, level1, level2) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  modules_lvl3 <- modules %>%
    select(sequence, level1, level2, level3) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2, level3) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  modules_lvl4 <- modules %>%
    select(sequence, level1, level2, level3, level4) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2, level3, level4) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  modules_lvl5 <- modules %>%
    select(sequence, level1, level2, level3, level4, KO, gene) %>%
    distinct %>%
    select(-sequence) %>%
    group_by(level1, level2, level3, level4, KO, gene) %>%
    tally %>%
    ungroup %>%
    rename(count = n)

  # Return results
  pathways <- list(level1 = pathways_lvl1,
                   level2 = pathways_lvl2,
                   level3 = pathways_lvl3,
                   level4 = pathways_lvl4)

  modules <- list(level1 = modules_lvl1,
                  level2 = modules_lvl2,
                  level3 = modules_lvl3,
                  level4 = modules_lvl4,
                  level5 = modules_lvl5)

  results <- new("sum_tbl", pathways = pathways, modules = modules)

  return(results)
}
