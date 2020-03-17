#' formatKEGG()
#'
#' Re-formats the KEGG auxiliary files for use with KEGG-tools.
#'
#' @param path Path to the root of the KEGG directory
#' @return
#'
#' @examples
#' formatKEGG("/home/ipessi/KEGG")

formatKEGG <- function(path) {
  PROKARYOTES.DAT <- paste(path, "prokaryotes.dat", sep = "/") %>%
    read_delim(delim = "\t", col_names = c("gene", "KO", "length", "gene_name")) %>%
    separate(KO, sep = ",", into = c("KO1", "KO2", "KO3")) %>%
    gather(key = "key", value = "KO", -c(gene, length, gene_name)) %>%
    # filter(key != "KO1" | ! KO %in% NA) %>% # REMOVE THIS LATER; KEEP GENES WITHOUT KO
    filter(key != "KO2" | ! KO %in% NA) %>%
    filter(key != "KO3" | ! KO %in% NA) %>%
    select(gene, KO)

  assign("PROKARYOTES.DAT", PROKARYOTES.DAT, .GlobalEnv)
  write_delim(paste(path, "PROKARYOTES.DAT", sep = "/"), delim = "\t")
}
