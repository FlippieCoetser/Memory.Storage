describe('Memory.Storage.Validator',{
  it('Exist',{
    Memory.Storage.Validator |> expect.exist()
  })
})

describe("When validators <- Memory.Storage.Validator()",{
  it("then validators is a list",{
    # When
    validators <- Memory.Storage.Validator()
    
    # Then
    validators |> expect.list()
  })
  it('then validators contains NoImplementation validator',{
   # When
   validators <- Memory.Storage.Validator()
   
   # Then
   validators[['NoImplementation']] |> expect.exist()
  })
  it('then validators contains IsNewEntity validator',{
   # When
   validators <- Memory.Storage.Validator()
   
   # Then
   validators[['IsNewEntity']] |> expect.exist()
  })
  it('then validators contains EntityExist validator',{
   # When
   validators <- Memory.Storage.Validator()
   
   # Then
   validators[['EntityExist']] |> expect.exist()
  })
  it('then validators contains UniqueIdentifier validator',{
   # When
   validators <- Memory.Storage.Validator()
   
   # Then
   validators[['UniqueIdentifier']] |> expect.exist()
  })
})

describe("When throw |> validate[['NoImplementation']]()",{
  it("then an exceptions is thrown if throw is TRUE",{
    # Given
    validators <- Memory.Storage.Validator()

    throw <- TRUE
    
    expected.error <- 'Memory Storage Provider Error: ExecuteQuery not implemented.'
    
    # When
    throw |> validators[['NoImplementation']]() |> expect.error(expected.error)
  })
})

describe("When entity |> validate[['IsNewEntity']](table)",{
  it("then an exception is thrown if entity exist in memory storage",{
    # Given
    configuration <- data.frame()

    broker <- configuration |> Memory.Storage.Broker()

    table <- 'Todo'
    Todo.Mock.Data |> broker[['Seed']](table)

    validator <- broker |> Memory.Storage.Validator()

    existing.entity <- Todo.Mock.Data |> tail(1)
    
    expected.error <- 'Memory Storage Provider Error: Duplicate Id not allowed.'
    
    # Then
    existing.entity |> validator[['IsNewEntity']](table) |> expect.error(expected.error)
  })  
})

describe("When entity |> validate[['EntityExist']](table)",{
  it("then an exception is thrown if entity does not exist in memory storage",{
    # Given
    configuration <- data.frame()

    broker <- configuration |> Memory.Storage.Broker()

    table <- 'Todo'
    Todo.Mock.Data |> broker[['Seed']](table)

    validator <- broker |> Memory.Storage.Validator()

    new.entity <- data.frame(
      Id     = uuid::UUIDgenerate(),
      Task   = 'Task',
      Status = 'New'
    )
    
    expected.error <- 'Memory Storage Provider Error: Entity not found.'
    
    # Then
    new.entity |> validator[['EntityExist']](table) |> expect.error(expected.error)
  })  
})

describe("When table |> validate[['IsValidTable']]()",{
  it("then no exception is thrown if table is a valid table",{
    # Given
    configuration <- data.frame()

    broker <- configuration |> Memory.Storage.Broker()

    table <- 'Todo'
    Todo.Mock.Data |> broker[['Seed']](table)

    validator <- broker |> Memory.Storage.Validator()

    valid.table <- table
    
    # Then
    valid.table |> validator[['IsValidTable']]() |> expect.no.error()
  })
  it("then an exception is thrown if table is not a valid table",{
    # Given
    configuration <- data.frame()

    broker <- configuration |> Memory.Storage.Broker()

    table <- 'Todo'
    Todo.Mock.Data |> broker[['Seed']](table)

    validator <- broker |> Memory.Storage.Validator()

    invalid.table <- 'InvalidTable'
    
    expected.error <- 'Memory Storage Provider Error: InvalidTable is not a valid table.'
    
    # Then
    invalid.table |> validator[['IsValidTable']]() |> expect.error(expected.error)
  })
})

describe("When id |> validate[['UniqueIdentifier']]()",{
  it('then no exception is thrown if id is a valid unique identifier',{
    # Given
    configuration <- data.frame()

    broker <- configuration |> Memory.Storage.Broker()
    validator <- broker |> Memory.Storage.Validator()

    valid.id <- uuid::UUIDgenerate()
    
    # Then
    valid.id |> validator[['UniqueIdentifier']]() |> expect.no.error()
  })
  it('then an exception is thrown if id is an invalid identifier',{
    # Given
    configuration <- data.frame()

    broker <- configuration |> Memory.Storage.Broker()
    validator <- broker |> Memory.Storage.Validator()

    invalid.id <- 'InvalidIdentifier'
    
    expected.error <- 'Memory Storage Provider Error: Invalid Unique Identifier.'
    
    # Then
    invalid.id |> validator[['UniqueIdentifier']]() |> expect.error(expected.error)
  })
})