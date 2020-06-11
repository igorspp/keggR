#' readBlast()
#'
#' Read BLAST results in the tabular format (outfmt 6).
#'
#' @param file BLAST file
#' @param evalue Double
#' @return A keggR BLAST table
#' @export
#' @examples
#' readBlast("examples/input_data.txt")

readBlast <- function(file, evalue = 1) {
  # Check input
  test_input <- suppressMessages(read_delim(file, delim = "\t", n_max = 1, col_names = F))

  if(test_input %>% names %>% length != 12) {
    stop("file does not look like a BLAST tabular table (outfmt 6)")
  }

  EVALUE = evalue

  # Read data
  data <-  read_delim(file, delim = "\t",
                      col_names = c("qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore"),
                      col_types = cols_only(qseqid = col_character(), sseqid = col_character(), evalue = col_double()))

  # Filter based on e-value
  data <- data %>%
    filter(evalue < EVALUE) %>%
    select(sequence = qseqid, target = sseqid, evalue)

  # Compact data frame
  data <- data %>%
    group_by(target) %>%
    mutate(sequence = paste0(sequence, collapse = "!!!")) %>%
    mutate(evalue = paste0(evalue, collapse = "!!!")) %>%
    unique %>%
    ungroup

  # Return results
  results <- new("blast_tbl", data = data)

  return(results)
}
