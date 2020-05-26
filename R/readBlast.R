#' readBlast()
#'
#' Read BLAST results.
#'
#' @param input BLAST file
#' @return A keggR blast table
#' @export
#' @examples
#' readBlast("/examples/input_data.txt")

# ADD CHECK TO NOT ALLOW COMMAS IN SEQUENCE NAME

readBlast <- function(file, e_value = FALSE) {
  data <-  read_delim(file,
                      delim = "\t",
                      col_names = c("qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore"),
                      col_types = cols_only(qseqid = col_character(), sseqid = col_character(), evalue = col_double())) %>%
    rename(sequence = qseqid, target = sseqid, e_value = evalue) %>%
    arrange(sequence, target)

  e_values <- data %>%
    pull(e_value)

  data <- data %>%
    select(-e_value) %>%
    group_by(target) %>%
    mutate(sequence = paste0(sequence, collapse = ",")) %>%
    unique %>%
    ungroup

  if (isTRUE(e_value)) {
    results <- new("blast_tbl", data = data, e_value = e_values)
  } else {
    results <- new("blast_tbl", data = data)
  }

  return(results)
}
