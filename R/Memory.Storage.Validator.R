Memory.Storage.Validator <- \(broker = NULL) {
  exception <- Memory.Storage.Exceptions()

  validators <- list()
  validators[['Data']]             <- \(data) {
    data |> is.data.frame() |> isFALSE() |> exception[['InvalidDataType']]('data', 'data.frame')
    return(data)
  }
  validators[['Entity']]           <- \(entity) {
    entity |> is.data.frame() |> isFALSE() |> exception[['InvalidDataType']]('entity', 'data.frame')
    return(entity)
  }
  validators[['Table']]            <- \(table) {
    table |> is.character() |> isFALSE() |> exception[['InvalidDataType']]('table', 'character')
    return(table)
  }
  validators[['Id']]               <- \(id) {
    id |> validators[['Identifier']]()
    return(id)
  }
  validators[['NoImplementation']] <- \(throw) {
    throw |> exception[['NoExecuteQuery']]()
  }
  validators[['IsNewEntity']]      <- \(entity, table) {
    match.count <- entity[['Id']] |> broker[['SelectWhereId']](table) |> nrow() 
    (match.count != 0) |> exception[['DuplicateId']]()
    return(entity)
  }
  validators[['EntityExist']]      <- \(entity, table) {
    match.count <- entity[['Id']] |> broker[['SelectWhereId']](table) |> nrow() 
    (match.count == 0) |> exception[['EntityNotFound']]()
    return(entity)
  }
  validators[['TableExist']]       <- \(table) {
    broker[['GetTableNames']]() |> 
      is.element(table)         |> 
      isFALSE()                 |> 
      exception[['InvalidTable']](table)
    return(table)
  }
  validators[['Identifier']]       <- \(id) {
    pattern <- "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
    pattern |> grepl(id) |> isFALSE() |> exception[['InvalidIdentifier']]()
    return(id)
  }
  return(validators)
}