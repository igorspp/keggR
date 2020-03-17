KOtable2ANVIO <- function(input) {
  input %>%
    mutate(source = "KEGG") %>%
    select(sequence, source, KO, gene, evalue) %>%
    set_names(c("gene_callers_id", "source", "accession", "function", "e_value"))
}
