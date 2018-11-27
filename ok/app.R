runApp(list(
  ui = bootstrapPage(
    selectInput("density", 
                label = "Select density estimation method for LIME", 
                choices = c("Bins", "Kernel Density", "Normal Approximation")),
    uiOutput('bintype')
  ),
  server = function(input, output){
    output$bintype = renderUI({
      type = input$density
      selectInput('bintype2', 'Columns', ifelse(type == "Bins", "hi", "bye"))
    })
  }
))


runApp(list(
  ui = bootstrapPage(
    selectInput('dataset', 'Choose Dataset', c('mtcars', 'iris')),
    uiOutput('columns')
  ),
  server = function(input, output){
    output$columns = renderUI({
      mydata = get(input$dataset)
      selectInput('columns2', 'Columns', names(mydata))
    })
  }
))