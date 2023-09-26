#' Memory Storage Provider
#' 
#' @description
#' Provide a common interface to perform standard data operations on an in-memory data store
#'  
#' @usage NULL
#' @returns a list value: 
#' * `storage <- broker |> Memory.Storage.Service()`
#' * `storage[['Seed']](data, table)`
#' * `storage[['ExecuteQuery']](...)`
#' * `storage[['Insert']](entity, table)`
#' * `storage[['Select']](table, fields)`
#' * `storage[['SelectWhereId']](id, table, fields)`
#' * `storage[['Update']](entity, table)`
#' * `storage[['Delete']](id, table)`
#' @export
Memory.Storage.Service <- \(broker) {
  validate  <- Memory.Storage.Validator(broker)
  
  services <- list()
  services[['Seed']]          <- \(data, table) {
    data  |> validate[['Data']]()
    table |> validate[['Table']]()

    data |> broker[['Seed']](table)
  }
  services[['ExecuteQuery']]  <- \(...) {
    TRUE |> validate[['NoImplementation']]()
    ...  |> broker[['ExecuteQuery']]()
  }
  services[['Insert']]        <- \(entity, table) {
    entity |> validate[['Entity']]()
    table  |> validate[['Table']]()

    table |> validate[['IsValidTable']]()

    entity |> validate[['IsNewEntity']](table)
    entity |> broker[['Insert']](table)
  }
  services[['Select']]        <- \(table, fields) {
    table |> validate[['IsValidTable']]()
    table |> broker[['Select']](fields)
  }
  services[['SelectWhereId']] <- \(id, table, fields) {
    id |> validate[['Identifier']]()

    table |> validate[['IsValidTable']]()

    id |> broker[['SelectWhereId']](table, fields)
  }
  services[['Update']]        <- \(entity, table) {
    table |> validate[['IsValidTable']]()

    entity |> validate[['EntityExist']](table)
    entity |> broker[['Update']](table)
  }
  services[['Delete']]        <- \(id, table) {
    id |> validate[['Identifier']]()

    table |> validate[['IsValidTable']]()
    
    id |> broker[['Delete']](table)
  }
  return(services)
}