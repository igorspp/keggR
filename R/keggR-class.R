#' @export
setClass("blast_tbl", slots = list(data = "data.frame"))

#' @export
setClass("ko_tbl", slots = list(data = "data.frame"))

#' @export
setMethod("show", "blast_tbl", function(object) {
  print(getBlastTable(object))
})

#' @export
setMethod("show", "ko_tbl", function(object) {
  print(getKOtable(object))
})
