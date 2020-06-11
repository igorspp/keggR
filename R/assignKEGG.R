#' assignKEGG()
#'
#' assignKEGG.
#'
#' @param input keggR BLAST table
#' @return A keggR KO table
#' @export
#' @examples
#' assignKEGG(blast)

assignKEGG <- function(input) {
  # Check input
  if (class(input)[1] != "blast_tbl") {
    stop("input is not a keggR BLAST table object")
  }

  # Check if auxiliary files are loaded
  if (!exists(".PROKARYOTES.DAT") | !exists(".KO00000")) {
    stop("please run loadKEGG() first")
  }

  # Get BLAST table
  data <- input %>%
    getBlastTable

  # Detect BLAST table type
  if("target" %in% names(data)) {
    TYPE <- 1
  } else {
    TYPE <- 2
  }

  # Assign KOs
  if(TYPE == 1) {
    data <- data %>%
      left_join(.PROKARYOTES.DAT, by = c("target" = "gene")) %>%
      filter(! KO %in% NA) %>%
      select(-target)
  }

  # Assign gene names
  data <- data %>%
    left_join(.KO00000, by = "KO") %>%
    select(sequence, KO, gene, evalue)

  # Compact data frame
  data <- data %>%
    group_by(KO, gene) %>%
    mutate(sequence = paste0(sequence, collapse = "!!!")) %>%
    mutate(evalue = paste0(evalue, collapse = "!!!")) %>%
    unique %>%
    ungroup

  # Return results
  results <- new("ko_tbl", data = data)

  return(results)
}

