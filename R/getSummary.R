#' getSummary()
#'
#' getSummary.
#'
#' @param input keggR summary table
#' @return A tibble
#' @export
#' @examples
#' getSummary(summary)

# ADD CHECK FOR sum_tbl

getSummary <- function(input, mode = "pathways", level = "level1") {
  MODE <- c("pathways", "modules")

  if (is.na(pmatch(mode, MODE)))
    stop("mode has to be one of c('pathways', 'modules')")

  if (mode == "pathways") {
    LEVEL <- c("level1", "level2", "level3", "level4")

    if (is.na(pmatch(level, LEVEL)))
      stop("level has to be one of c('level1', 'level2', 'level3', 'level4')")
  }
  else {
    LEVEL <- c("level1", "level2", "level3", "level4", "level5")

    if (is.na(pmatch(level, LEVEL)))
      stop("level has to be one of c('level1', 'level2', 'level3', 'level4', 'level5')")
  }

  input <- input %>%
    as.list

  object <- input[[mode]][[level]] %>%
    as_tibble

  return(object)
}
