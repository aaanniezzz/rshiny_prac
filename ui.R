## Script Name: ui.R
## Purpose: Practice my shiny skills
## Author: Annie Zhu
## Date Created: 7/8/2021
## 
## Notes:
##
##

## Load packages ##############################################################
if(!require("pacman")) install.packages("packman")
pacman::p_load(shiny,shinythemes,tidyverse,DT)

# DT: for interactive tables HTML widget


navbarPage( title = "Shiny Dashboard",
            theme = shinytheme("flatly"),
            # shinythemes::themeSelector(),
            id = "navbar",
            collapsible = T,
            
            #TAB 1 - Introduction #############################################
            navbarMenu( title = "Introduction"
                        
            ),#end of navbar 2
            
            
            #TAB 2 - Data Tables ##############################################
            navbarMenu( title = "Data Tables",
              
                        #. Panel 1 --------------------------------------------------------
                        tabPanel( title = "Multiple Datasets", 
                                  fluidPage(
                                    sidebarLayout(
                                      sidebarPanel(
                                        selectInput(inputId = "panel1_dataset", 
                                                    label = "Choose a dataset:",
                                                    choices = c(Choose=" ", "Cars","Star War"),
                                                    selectize = T),
                                        
                                        numericInput(inputId = "obs", 
                                                     label = "Number of Observation:",
                                                     value = 10),
                                        
                                        helpText("One dataset must be selected!"),
                                        actionButton(inputId = "update",
                                                     label = "Update View")
                                      ),
                                      mainPanel(h2("Table with Multiple Datasets"),
                                        tabsetPanel(
                                          tabPanel("Static Tables",
                                                   h4("Summary"), 
                                                   verbatimTextOutput("summary"), 
                                                   
                                                   h4("Data"), 
                                                   tableOutput("static_view")
                                          ),
                                          tabPanel("Interactive Tables",
                                                   h4("Data"), 
                                                   checkboxInput(inputId = "rownames",
                                                                 label = "Include row names",
                                                                 value = F),
                                                   DTOutput("inter_view")
                                                   
                                          )
                                        )
                                      )
                                    )
                                  ) 
                                  
                          ),
              #. Panel 2 --------------------------------------------------------
              tabPanel( title = "Tables with Filters", 
                        fluidPage(
                          sidebarLayout(
                            sidebarPanel(
                              h3("Filters"),
                              conditionalPanel(
                                'input.panel2_dataset === "MPG"',
                                checkboxGroupInput(inputId = "mpg_filter", 
                                                   label = "Select columns to show:",
                                                   choices = names(mpg), 
                                                   selected = names(mpg)),
                                helpText("Click on column names to reorder.")
                              ),
                              conditionalPanel(
                                'input.panel2_dataset === "DIAMONDS"',
                                checkboxGroupInput(inputId = "diamond_filter", 
                                                    label = "Choose Columns:",
                                                    choices = names(diamonds),
                                                    selected = names(diamonds))
                              ),
                              
                              
                            ), # end of sidebarPanel
                            
                            mainPanel( h2("Data Table with Flexible Filters"),
                                    
                                      tabsetPanel( id = "panel2_dataset",
                                        tabPanel("MPG",
                                                 fluidRow(
                                                   column(width = 4,
                                                          selectInput(inputId = "select_manuf",
                                                                      label = "Manufacturer:", 
                                                                      choices = c("All",as.character(unique(mpg$manufacturer)))
                                                                      )),
                                                  column(width = 4,
                                                         selectInput(inputId = "select_cyl",
                                                                     label = "Cylinders:", 
                                                                     choices = c("All",as.character(unique(mpg$cyl)))
                                                                 ))
                                                         ),
                                                 DTOutput("mpg_table")),
                                                 
                                        tabPanel("DIAMONDS",
                                                 fluidRow(
                                                   column(width = 4,
                                                          selectInput(inputId = "select_cut",
                                                                      label = "Cut:", 
                                                                      choices = c("All",as.character(unique(diamonds$cut)))
                                                          )),
                                                   column(width = 4,
                                                          selectInput(inputId = "select_clarity",
                                                                      label = "Clarity:", 
                                                                      choices = c("All",as.character(unique(diamonds$clarity)))
                                                          ))
                                                 ),
                                                 DTOutput("dimonds_table")))
                                        
                            )  # end of mainPanel 
                          ) # end of sidebarLayout
                        ) # end of fluidPage
                    ) #end of panel 2
                        
              ), #end of navbar 2
            
            #TAB 3 - Simple Charts ############################################
            navbarMenu( title = "Simple Charts"
                        
            )
)