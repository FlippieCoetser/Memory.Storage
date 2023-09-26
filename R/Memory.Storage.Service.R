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

    data  |> broker[['Seed']](table)
  }
  services[['ExecuteQuery']]  <- \(...) {
    TRUE |> validate[['NoImplementation']]()
    ...  |> broker[['ExecuteQuery']]()
  }
  services[['Insert']]        <- \(entity, table) {
    entity |> validate[['Entity']]()
    table  |> validate[['Table']]()
    
    entity |> validate[['IsNewEntity']](table)
    table  |> validate[['TableExist']]()
    
    entity |> broker[['Insert']](table)
  }
  services[['Select']]        <- \(table, fields) {
    table |> validate[['Table']]()

    table |> validate[['TableExist']]()

    table |> broker[['Select']](fields)
  }
  services[['SelectWhereId']] <- \(id, table, fields) {
    id    |> validate[['Id']]()
    table |> validate[['Table']]()

    table |> validate[['TableExist']]()

    id |> broker[['SelectWhereId']](table, fields)
  }
  services[['Update']]        <- \(entity, table) {
    entity |> validate[['Entity']]()
    table  |> validate[['Table']]()

    table  |> validate[['TableExist']]()

    entity |> validate[['EntityExist']](table)
    entity |> broker[['Update']](table)
  }
  services[['Delete']]        <- \(id, table) {
    id    |> validate[['Id']]()
    table |> validate[['Table']]()

    table |> validate[['TableExist']]()
    
    id    |> broker[['Delete']](table)
  }
  return(services)
}