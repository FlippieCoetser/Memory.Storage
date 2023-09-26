describe('Todo.Mock.Data',{
  it('Exist',{
    Todo.Mock.Data |> expect.exist()
  })
})

describe('when todos <- Todo.Mock.Data',{
  it('then todos is a data.frame',{
    # When
    todos <- Todo.Mock.Data

    # Then
    todos |> expect.data.frame() 
  })
  it('then todos contains 3 rows',{
    # When
    todos <- Todo.Mock.Data

    # Then
    todos |> expect.rows(3)
  })
})