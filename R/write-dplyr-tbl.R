#' Write dbplyr query to snowflake database
#'
#' This is a simple function to write a dbplyr query to a demo snowflake database
#' @param con connection to database
#' @param dbplyr_tbl dbplyr query
#' @param table_name the name of the table to be written
#' @param schema the schema to be used
#'
#' @importFrom dbplyr sql_render
#' @importFrom DBI dbExistsTable dbSendQuery
#' @importFrom glue glue
#'
#' @export
#'
write_dbplyr_tbl <- function(con, dplyr_tbl, table_name, schema){
  sql_string <- dbplyr::sql_render(dplyr_tbl)

  table_exists <- DBI::dbExistsTable(con, name = table_name, schema = schema)

  if(isTRUE(table_exists)){
    DBI::dbSendQuery(con, glue::glue('DROP TABLE "SMARTENERGI_DATALAKE_SANDBOX"."{schema}"."{table_name}"'))
  }

  sql_create <- paste(glue::glue('CREATE TABLE "SMARTENERGI_DATALAKE_SANDBOX"."{schema}"."{table_name}" as'), sql_string)

  DBI::dbSendQuery(con, sql_create)

}
