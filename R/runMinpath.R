#' runMinpath()
#'
#' runMinpath.
#'
#' @param input keggR KO table
#' @return A keggR KO table
#' @export
#' @examples
#' runMinpath(KOtable)

# ADD CHECK FOR ko_tbl
# ADD CHECK FOR loadKEGG()
# ADD CHECK FOR MINPATH

runMinpath <- function (input, debug = FALSE) {
  seqs  <- input@seqs
  stats <- input@stats
  input <- getKOtable(input)

  minpath <- list(run = TRUE,
                  pathways = list(bad = NULL,
                                  good = NULL),
                  modules = list(bad = NULL,
                                 good = NULL))

  # Prepare files for MinPath
  input %>%
    filter(pathway != "") %>%
    select(sequence, KO) %>%
    unique %>%
    write_delim("minpath.pathways.in.txt", delim = "\t", col_names = F)

  input %>%
    filter(module != "") %>%
    select(sequence, KO) %>%
    unique %>%
    write_delim("minpath.modules.in.txt", delim = "\t", col_names = F)

  # Workaroud for accessing the map files
  write_delim(.KO00001.minpath, "KO00001.minpath", delim = "\t", col_names = F)
  write_delim(.KO00002.minpath, "KO00002.minpath", delim = "\t", col_names = F)

  # Run Minpath
  system2("/bin/bash", args = c('-ic', shQuote('MinPath1.4.py -any minpath.pathways.in.txt -map KO00001.minpath -report minpath.pathways.out.txt &> minpath.pathways.log.txt')))
  system2("/bin/bash", args = c('-ic', shQuote('MinPath1.4.py -any minpath.modules.in.txt  -map KO00002.minpath -report minpath.modules.out.txt  &> minpath.modules.log.txt')))

  # Read MinPath results
  minpath_pathways <- read_delim("minpath.pathways.out.txt", delim = " ", trim_ws = T, col_names = F,
                                 col_types = cols_only(X8 = col_integer(), X14 = col_character())) %>%
    rename(present = X8, pathway = X14)

  minpath_modules <- read_delim("minpath.modules.out.txt", delim = " ", trim_ws = T, col_names = F,
                                col_types = cols_only(X8 = col_integer(), X14 = col_character())) %>%
    rename(present = X8, module = X14)

  # Parse results
  minpath[["pathways"]][["good"]] <- minpath_pathways %>%
    filter(present == 1) %>%
    pull(pathway) %>%
    gsub("_", " ", .)

  minpath[["pathways"]][["bad"]] <- minpath_pathways %>%
    filter(present == 0) %>%
    pull(pathway) %>%
    gsub("_", " ", .)

  minpath[["modules"]][["good"]] <- minpath_modules %>%
    filter(present == 1) %>%
    pull(module) %>%
    gsub("_", " ", .)

  minpath[["modules"]][["bad"]] <- minpath_modules %>%
    filter(present == 0) %>%
    pull(module) %>%
    gsub("_", " ", .)

  # Remove temporary files
  if (debug == FALSE) {
    file.remove("KO00001.minpath")
    file.remove("KO00002.minpath")
    file.remove("minpath.pathways.in.txt")
    file.remove("minpath.pathways.out.txt")
    file.remove("minpath.pathways.log.txt")
    file.remove("minpath.modules.in.txt")
    file.remove("minpath.modules.out.txt")
    file.remove("minpath.modules.log.txt")
  }

  # Get results
  results <- new("ko_tbl", seqs = seqs, stats = stats, minpath = minpath, data = input)

  return(results)
}
