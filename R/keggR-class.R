#' @export
setClass("blast_tbl", slots = list(data = "data.frame",
                                   e_value = "numeric"))

#' @export
setClass("ko_tbl", slots = list(stats = "list",
                                minpath = "list",
                                data = "data.frame",
                                e_value = "numeric"))

#' @export
setClass("sum_tbl", slots = list(pathways = "list",
                                 modules = "list"))

#' @export
setMethod("show", "blast_tbl", function(object) {
  cat("keggR BLAST table\n")
  cat("Access data with getBlastTable()\n")
})

#' @export
setMethod("show", "ko_tbl", function(object) {
  cat("keggR KO table\n")
  cat("Access data with getKOtable()\n")

  cat("\nSEQUENCES\n")
  cat("---------\n")
  cat("Sequences in input file:              ", object@stats[["nseqs"]][["total"]], "\n")
  cat("Sequences assigned to a KO identifier:", object@stats[["nseqs"]][["KO"]], "\n")
  cat("Sequences assigned to a pathway:      ", object@stats[["nseqs"]][["pathways"]], "\n")
  cat("Sequences assigned to a module:       ", object@stats[["nseqs"]][["modules"]], "\n")

  cat("\nPATHWAYS\n")
  cat("--------\n")
  cat("Number of pathways:", object@stats[["pathways"]], "\n")

  cat("\nMODULES\n")
  cat("-------\n")
  cat("Number of modules:", object@stats[["modules"]], "\n")

  cat("\nMINPATH\n")
  cat("-------\n")

  if (object@minpath[["run"]] == FALSE) {
    cat("NOT FOUND\n")
  }
  else {
    cat("Pathways removed:", object@minpath[["pathways"]][["bad"]] %>% length, "\n")
    cat("Modules removed: ", object@minpath[["modules"]][["bad"]] %>% length, "\n")
  }
})

#' @export
setMethod("show", "sum_tbl", function(object) {
  cat("keggR summary table\n")
  cat("Access data with getSummary()\n")
})

#' @export
as.list.sum_tbl <- function(x) {
  list(pathways = x@pathways,
       modules = x@modules)
}
setMethod("as.list", "sum_tbl", as.list.sum_tbl)

#' @export
as_blast_tbl <- function(x) {
  # ADD CHECK FOR COLUMNS
  object <- x %>%
    select(sequence, target)

  object <- new("blast_tbl", data = x)

  return(object)
}

