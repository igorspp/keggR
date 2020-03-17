#' loadKEGG()
#'
#' Load the KEGG auxiliary files.
#'
#' @param path Folder containing the KEGG auxiliary files
#' @return
#' @export
#' @examples
#' loadKEGG("/home/igorspp/KEGG")

loadKEGG <- function(path) {
  cat("Reading PROKARYOTES.DAT\n")

  PROKARYOTES.DAT <- paste(path, "PROKARYOTES.DAT", sep = "/") %>%
    read_delim(delim = "\t", col_types = "cc", progress = T)

  cat("Reading KO00000\n")
  KO00000 <- paste(path, "KO00000", sep = "/") %>%
    read_delim(delim = "\t", col_types = "cc", progress = F)

  cat("Reading KO00001\n")
  KO00001 <- paste(path, "KO00001", sep = "/") %>%
    read_delim(delim = "\t", col_types = "cccc", progress = F)

  cat("Reading KO00002\n")
  KO00002 <- paste(path, "KO00002", sep = "/") %>%
    read_delim(delim = "\t", col_types = "ccccc", progress = F)

  cat("Reading files for MinPath\n")
  KO00001.minpath <- paste(path, "KO00001.minpath", sep = "/") %>%
    read_delim(delim = "\t", col_types = "cc", col_names = F, progress = F)
  KO00002.minpath <- paste(path, "KO00002.minpath", sep = "/") %>%
    read_delim(delim = "\t", col_types = "cc", col_names = F, progress = F)

  assign(".PROKARYOTES.DAT", PROKARYOTES.DAT, .GlobalEnv)
  assign(".KO00000", KO00000, .GlobalEnv)
  assign(".KO00001", KO00001, .GlobalEnv)
  assign(".KO00002", KO00002, .GlobalEnv)
  assign(".KO00001.minpath", KO00001.minpath, .GlobalEnv)
  assign(".KO00002.minpath", KO00002.minpath, .GlobalEnv)
}
