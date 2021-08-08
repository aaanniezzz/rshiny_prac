## Script Name: server.R
## Purpose: Practice my shiny skills
## Author: Annie Zhu
## Date Created: 7/8/2021
## 
## Notes:
##
##

function(input,output) {
  
  #. Panel 1 --------------------------------------------------------
  # Reactive function for update button
  datasetInput <- eventReactive(input$update, {
    switch(input$panel1_dataset,
           "Cars" = mtcars,
           "Star War" = starwars)
  }, ignoreNULL = F)
  
  # Reactive function for data selected
  datanameInput <- eventReactive(input$update, {
    switch(input$panel1_dataset,
           " "=0,
           "Cars" = 1,
           "Star War" = 2)
  }, ignoreNULL = F)
  
  # Summary Table output  
  output$summary <- renderPrint({
    dataset <- datasetInput()
    if(datanameInput()!=0){
      
      if(datanameInput()==1){
        dataset %>%
          select(mpg:hp) %>%
          summary()
        
      }
      else{ # if(datanameInput()==2)
        # Table Option 2: use head() with isolate for nrows
        # isolate input so view only update if action button is pressed
        dataset %>%
          select(sex:species) %>%
          summary()
      }
    }
  })
  
  output$static_view <- renderTable({
    dataset <- datasetInput()
    if(datanameInput()!=0){
      
      # Table Option 1: use dplyr
      if(datanameInput()==2){
        dataset %>%
          select(name:birth_year) %>%
          arrange(desc(height)) %>%
          setNames(str_to_title(names(.))) %>%    # Change first letter to capital
          head(n=isolate(input$obs))     
        
      }else{
        # Table Option 2: use head() with isolate for nrows
        # isolate input so view only update if action button is pressed
        dataset %>%
          setNames(str_to_title(names(.))) %>%    # Change first letter to capital
          head(n=isolate(input$obs))
      }
    }
    
  }, striped = T, # create striped table
  hover = T,    # highlight row when hovering
  na= "[N/A]"   # Replace NA with custom string 
  )
  
  output$inter_view <- renderDT({
    dataset <- datasetInput()
    # Table Option 1: use dplyr
    if(datanameInput()==2){
      dataset %>%
        select(name,height,homeworld,films:starships) %>% 
        # works for list objects
        arrange(desc(height)) %>% 
        datatable(rownames = input$rownames,
                  extensions = "Responsive")
      
      
    }else{
      # Table Option 2: use head() with isolate for nrows
      # isolate input so view only update if action button is pressed
      dataset
    }
    
  } #   rownames = F to turn off rownames completely
  )
  
  
  #. Panel 2 --------------------------------------------------------
  diamonds <- diamonds[sample(nrow(diamonds), 1000), ]
  
  output$dimonds_table <- renderDT({
    if(input$select_cut!="All"){
      diamonds <- diamonds %>%
        filter(cut==input$select_cut)
    }
    if(input$select_clarity!="All"){
      diamonds <- diamonds %>%
        filter(clarity==input$select_clarity)
    }
    diamonds %>%
      select(input$diamond_filter) %>%
      #  select(cut,clarity,everything()) %>% # reorder columns - doesn't work with checkbox
      datatable(rownames = F, extensions = "Responsive") 
  })
  
  #mpg table
  output$mpg_table <- renderDT({
    if(input$select_manuf!="All"){
      mpg <- mpg %>%
        filter(manufacturer==input$select_manuf)
    }
    if(input$select_cyl!="All"){
      mpg <- mpg %>%
        filter(cyl==input$select_cyl)
    }
    mpg %>%
      select(input$mpg_filter) %>%
      #  select(manufacturer, cyl, everything()) %>%
      datatable(options = list(lengthMenu = c(5, 30, 50), pageLength = 5),
                rownames = F, extensions = "Responsive") 
    
  })
  
  
}
