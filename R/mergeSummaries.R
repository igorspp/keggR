#' mergeSummaries()
#'
#' mergeSummaries.
#'
#' @param input List of keggR summary tables
#' @return A list
#' @export
#' @examples
#' mergeSummaries(list)

mergeSummaries <- function(input) {
  SAMPLES <- input %>%
    names

  # Pathways
  pathways_lvl1 <- lapply(SAMPLES, function(x) {
    input[[x]][["pathways"]][["level1"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  pathways_lvl2 <- lapply(SAMPLES, function(x) {
    input[[x]][["pathways"]][["level2"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  pathways_lvl3 <- lapply(SAMPLES, function(x) {
    input[[x]][["pathways"]][["level3"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  pathways_lvl4 <- lapply(SAMPLES, function(x) {
    input[[x]][["pathways"]][["level4"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  # Modules
  modules_lvl1 <- lapply(SAMPLES, function(x) {
    input[[x]][["modules"]][["level1"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  modules_lvl2 <- lapply(SAMPLES, function(x) {
    input[[x]][["modules"]][["level2"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  modules_lvl3 <- lapply(SAMPLES, function(x) {
    input[[x]][["modules"]][["level3"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  modules_lvl4 <- lapply(SAMPLES, function(x) {
    input[[x]][["modules"]][["level4"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

  modules_lvl5 <- lapply(SAMPLES, function(x) {
    input[[x]][["modules"]][["level5"]] %>%
      mutate(sample = x)
  }) %>% bind_rows %>%
    spread(sample, count, fill = 0)

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

  results <- list(pathways = pathways, modules = modules)

  return(results)
}
