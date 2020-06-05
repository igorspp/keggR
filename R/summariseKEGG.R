#' summariseKEGG()
#'
#' summariseKEGG.
#'
#' @param input keggR KO table
#' @return A list
#' @export
#' @examples
#' summariseKEGG(KOtable)

summariseKEGG <- function(input, minpath = NULL, debug = FALSE) {
  # Check input
  if (class(input)[1] != "ko_tbl") {
    stop("input is not a keggR KO table object")
  }

  # Check if auxiliary files are loaded
  if (!exists(".KO00001") | ! exists(".KO00001.minpath") | !exists(".KO00002") | !exists(".KO00002.minpath")) {
    stop("please run loadKEGG() first")
  }

  # Get KO table
  data <- input %>%
    getKOtable

  # If there are multiple hits per sequence, keep only lowest evalue
  data <- data %>%
    group_by(sequence) %>%
    arrange(desc(evalue)) %>%
    slice(1) %>%
    ungroup %>%
    select(-evalue)

  # Assign pathways
  pathways <- data %>%
    left_join(.KO00001, by = "KO") %>%
    filter(level1 != "")

  # Assign modules
  modules <- data %>%
    left_join(.KO00002, by = "KO") %>%
    filter(level1 != "")

  # Run Minpath?
  if(!is_null(minpath)) {
    ## Prepare files
    data %>%
      select(sequence, KO) %>%
      write_delim("minpath.in", delim = "\t", col_names = F)

    ## Workaroud for accessing the map files
    write_delim(.KO00001.minpath, "KO00001.minpath", delim = "\t", col_names = F)
    write_delim(.KO00002.minpath, "KO00002.minpath", delim = "\t", col_names = F)

    ## Run Minpath
    Sys.setenv(PATH = paste(minpath, Sys.getenv("PATH"), sep = .Platform$path.sep), MinPath = minpath)

    system("bash -c 'MinPath1.4.py -any minpath.in -map KO00001.minpath -report minpath.pathways.out &> minpath.pathways.log'")
    system("bash -c 'MinPath1.4.py -any minpath.in -map KO00002.minpath -report minpath.modules.out  &> minpath.modules.log'")

    ## Read MinPath results
    minpath_pathways <- read_delim("minpath.pathways.out", delim = " ", trim_ws = T, col_names = F, col_types = cols_only(X8 = col_integer(), X14 = col_character())) %>%
      rename(present = X8, pathway = X14)

    minpath_modules <- read_delim("minpath.modules.out", delim = " ", trim_ws = T, col_names = F, col_types = cols_only(X8 = col_integer(), X14 = col_character())) %>%
      rename(present = X8, module = X14)

    ## Parse results
    minpath_pathways_good <- minpath_pathways %>%
      filter(present == 1) %>%
      pull(pathway) %>%
      gsub("_", " ", .)

    pathways <- pathways %>%
      filter(level3 %in% minpath_pathways_good)

    minpath_modules_good <- minpath_modules %>%
      filter(present == 1) %>%
      pull(module) %>%
      gsub("_", " ", .)

    modules <- modules %>%
      filter(level4 %in% minpath_modules_good)

    # Remove temporary files
    if(isFALSE(debug)) {
      file.remove("KO00001.minpath")
      file.remove("KO00002.minpath")
      file.remove("minpath.in")
      file.remove("minpath.pathways.out")
      file.remove("minpath.pathways.log")
      file.remove("minpath.modules.out")
      file.remove("minpath.modules.log")
    }
  }

  # Pathways
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

  results <- list(pathways = pathways, modules = modules)

  return(results)
}
