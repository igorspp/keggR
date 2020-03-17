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

readBlast <- function(file) {
  object <-  read_delim(file,
                        delim = "\t",
                        col_names = c("qseqid", "sseqid", "pident", "length", "mismatch", "gapopen", "qstart", "qend", "sstart", "send", "evalue", "bitscore"),
                        col_types = cols_only(qseqid = col_character(), sseqid = col_character())) %>%
    rename(sequence = qseqid, target = sseqid) %>%
    group_by(target) %>%
    mutate(sequence = paste0(sequence, collapse = ",")) %>%
    unique %>%
    ungroup

  results <- new("blast_tbl", data = object)

  return(results)
}
