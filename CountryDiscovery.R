# import library
library(shiny)       # to build rich and productive interactive web apps in R
library(DT)          # to create an HTML widget to display rectangular data (a matrix or data frame)
library(dplyr)       # used in data selection and group data
library(shinythemes) # to have better user interface in shiny
library(stringr)     # to trim string vectors

# read all the dataset and using dataset1 as the base
mydata <- data.frame(read.csv("dataset1.csv"))
extra1 <- data.frame(read.csv("dataset2.csv"))
extra2 <- data.frame(read.csv("dataset3.csv"))
extra3 <- data.frame(read.csv("dataset4.csv"))
extra4 <- data.frame(read.csv("dataset5.csv"))
extra5 <- data.frame(read.csv("dataset6.csv"))
extra6 <- data.frame(read.csv("dataset7.csv"))
extra7 <- data.frame(read.csv("dataset8.csv"))
extra8 <- data.frame(read.csv("dataset9.csv"))

# select and combine the wanted variables(columns) in the datasets
mydata <- mydata[,c(1:4, 8:10)]
mydata <- cbind(mydata, extra1[,2])
mydata <- cbind(mydata, extra2[,2])
mydata <- cbind(mydata, extra3[,-c(1,3,4)])
mydata <- cbind(mydata, extra4[,c(2,4,6)])
mydata <- cbind(mydata, extra5[,2])
mydata <- cbind(mydata, extra6[,2])
mydata <- cbind(mydata, extra7[,3])
mydata <- cbind(mydata, extra8[,2])

# assume the NA as 0 for easier calculations and visualizations
mydata[is.na(mydata)] = 0

# create new column names
col_names <- c("Country","Region","Population","Area (sq. mi.)",
               "Infant Mortality (per 1000 births)","GDP ($ per capita)",
               "Literacy (%)","Suicide Rate","Urbanization Rate",
               "Cost of Living Index","Groceries Index","Restaurant Price Index",   
               "Local Purchasing Power Index","Total COVID-19 Cases",
               "Total COVID-19 Deaths","Total COVID-19 Recovered", 
               "Outdoor Pollution (deaths per 100000)","Total Fertility Rate",
               "Happiness Score","Crime Index")

# edit the column names in the dataset
colnames(mydata) <- col_names

# delete the tab space for the "Region" in the dataset
mydata$Region <- str_trim(mydata$Region)

ui <- fluidPage(
  theme = shinytheme("flatly"), # using "flatly" as the theme for shiny
  navbarPage(
    "Country Discovery",
   
    # create tab named "Data" to show the dataset                    
    tabPanel("Data", 
        titlePanel("Country Discovery"),
        h4("This program displays 19 different datasets of 97 different countries around the world!"),
        
        sidebarLayout(  
          sidebarPanel(
            textInput("name", "Your name:"),
            h6("Press submit to update changes!"),
            submitButton("Submit", icon("cog", lib = "glyphicon")) # create a submit button
          ),
                        
          mainPanel(
            h1(textOutput("greeting")),
            img(src = "World Map.png", height = 400, width = 1000), # insert a world map 
            DTOutput("obs") # present the dataset
          )
        )
    ),
            
    # create tab named "Structure" to have a simple glimpse at the dataset                   
    tabPanel("Structure", 
        h4("The output of str() function displays the internal structure of the overall datasets."), 
        verbatimTextOutput("structure")
    ),
   
    # create tab named "Summary" to show the descriptive analysis of the dataset                    
    tabPanel("Summary",
        h4("The output of summary() function shows a set of descriptive statistics for every variables."),
        verbatimTextOutput("summary")
    ),
   
    # create tab named "Exploration" to show the data of a selected country                  
    tabPanel("Exploration", 
        h4("The select() function in \"dplyr\" package is used to select desired variables while filter() function to 
           subset data with matching logical conditions."),
        sidebarLayout(  
          sidebarPanel(
            selectInput(inputId = "country", 
                        label = "Choose a country (Exploration):", 
                        choices = select(mydata, Country)),
            h6("Press submit to update changes!"),
            submitButton("Submit", icon("cog", lib = "glyphicon"))), # create a submit button
          
          mainPanel(verbatimTextOutput("country"))
        )
    ),
   
    # create tab named "Histogram" to show bar plots of the dataset                  
    tabPanel("Histogram",
        sidebarLayout(  
          sidebarPanel(
            selectInput(inputId = "feature",
                        label = "Choose a feature for histogram (based on country):", 
                        choices = colnames(mydata[3:20])),
            selectInput(inputId = "feature2",
                        label = "Choose a feature for histogram (based on region):", 
                        choices = colnames(mydata[c(3,4,14,15,16)])),
            checkboxInput("show_xlab", "Show/Hide X Axis Label", value = TRUE),
            checkboxInput("show_ylab", "Show/Hide Y Axis Label", value = TRUE),
            checkboxInput("show_title", "Show/Hide Title"),
            h6("Press submit to update changes!"),
            submitButton("Submit", icon("cog", lib = "glyphicon"))), # create a submit button
          
          mainPanel(plotOutput("plot"), plotOutput("plot2")) # show 2 bar plots
        )
    ),
   
    # create tab named "Scatter Plot" to show scatter plots of the dataset for 2 variables only                  
    tabPanel("Scatter Plot", 
        h4("The pairs() function is used to visualize possible correlated variables (2 different features in this case)."), 
        sidebarLayout(  
          sidebarPanel(
            selectInput(inputId = "feature3", 
                        label = "First feature (Scatter Plot):", 
                        choices = colnames(mydata[3:20])),
            selectInput(inputId = "feature4", 
                        label = "Second feature (Scatter Plot):", 
                        choices = colnames(mydata[3:20])),
            submitButton("Submit", icon("cog", lib = "glyphicon"))), # create a submit button
          
          mainPanel(plotOutput("scatterPlot"))
        )
    ),
   
    # create tab named "Documentation" to briefly explain the functions used                   
    tabPanel("Documentation", 
        h4("Country Discovery helps the user to look through different aspects 
            of countries and analysis are also provided by showing plots in data exploration!", br(), br(),
           
           "The libraries used are shiny, DT, dplyr, shinythemes and stringr.", br(), br(),
           
           "str() function returns many useful pieces of information.", br(), br(),
           
           "renderDT() and DTOutput() functions returns a container for table, and the latter is 
            used in the server logic to render the table.", br(), br(),
           
           "summary() function provides basic descriptive statistics and frequencies.", br(), br(),
           
           "select() function in \"dplyr\" package will extract the column of specific variable while 
           filter() function will extract the row of specific variable.", br(), br(),
           
           "par() function is used to set or query graphical parameters.", br(), br(),
           
           "barplot() function creates a bar plot with vertical or horizontal bars.", br(), br(),
           
           "group_by() function groups the dataset by one or more variables.", br(), br(),
           
           "summarise_at() function affects variables selected with a character vector or vars().", br(), br(),
           
           "range() function returns a vector containing the minimum and maximum of all the given arguments.", br(), br(),
           
           "paste() function concatenates vectors after converting to character.", br(), br(),
           
           "pairs() function checks possible correlated variables and produces a matrix of scatterplots.", br(), br(),
           
           "p() and a() functions are simple functions for constructing HTML documents.", br(),
           "p() function is used to represent a paragraph or a block of text.", br(),
           "a() function is used to link to another website."
        )
    ),
   
    # create tab named "Contributors" to give a simple introduction to the team members                   
    tabPanel("Contributors",
        titlePanel("List of contributors to Country Discovery"),
        
        p(span("Know about us"),style="color:blue;font-size:25px"),
        
        p("Country Discovery is a Shiny Web Application developed using R programming language.",style="font-size:20px"),
        
        p("The developmnet team consists of 4 members from University of Malaya taking",
          span(" WIE2003 - Introduction to Data Science ",style="color: orange; font-size:20px"), "course.",style="font-size:20px"),
        
        p(span("The team members:"),style="color:blue; font-size:25px"),
        
        p("Lim Jing Yao (U2005275)",style="color:green; font-size:20px"),
        
        p("Kong Jing Yuaan (U2005395)",style="color:green; font-size:20px"),
        
        p("Tiow Kit Keong (U2005264)",style="color:green; font-size:20px"),
        
        p("Yeo Jie Hui (U2005330)",style="color:green; font-size:20px")
    ),
   
    # create tab named "Credits" to show our references and sources                                               
    tabPanel("Credits",
        titlePanel("List of references and sources"),
        p("Description:",style="color:blue;font-size:25px"),
        
        a("https://www.kaggle.com/fernandol/countries-of-the-world", style="font-size:20px"),
        p("Retrieve Country, Region, GDP ($ per capita), Population, Infant Mortality (per 1000 births), Area (sq. mi.), Literacy (%)",style="font-size:21px"),
        
        a("https://www.kaggle.com/dumbgeek/countries-dataset-2020", style="font-size:20px"),
        p("Retrieve Cost of Living Index, Groceries Index, Restaurant Price Index, Local Purchasing Power Index, Crime Index",style="font-size:21px"),
        
        a("https://www.kaggle.com/daniboy370/world-data-by-country-2020", style="font-size:20px"),
        p("Retrieve Total Fertility Rate, Suicide Rate, Urbanization Rate",style="font-size:21px"),
        
        a("https://www.kaggle.com/brandonhoeksema/pollution-by-country-for-covid19-analysis", style="font-size:20px"),
        p("Retrieve Outdoor Pollution (deaths per 100000)",style="font-size:21px"),
        
        a("https://www.kaggle.com/unsdsn/world-happiness?select=2019.csv", style="font-size:20px"),
        p("Retrieve Happiness Score",style="font-size:21px"),
        
        a("https://www.kaggle.com/nilimajauhari/covid19-all-countries-data", style="font-size:20px"),
        p("Retrieve Total Covid-19 Cases, Total Covid-19 Deaths, Total Covid-19 Recovered",style="font-size:21px")
    )
  )
)


server <- function(input, output){
  
  # output the entered name
  string <- reactive(paste("Hello and Welcome ", input$name, "!"))
  output$greeting <- renderText(string())

  # output the structure of the dataset
  output$structure <- renderPrint({str(mydata)})
  
  # present the dataset
  output$obs <- renderDT({mydata})
  
  # output a descriptive analysis of the dataset
  output$summary <- renderPrint({summary(mydata)})
  
  # output the features of a selected country
  output$country <- renderPrint({filter(mydata, Country == input$country)})
  
  # create a bar plot based on country
  output$plot <- renderPlot({
    barplot(
      mydata[[input$feature]],
      main = ifelse(input$show_title, paste("Histogram of", input$feature, "based on country"), ""),
      xlab = ifelse(input$show_xlab, "Country", ""),
      ylab = ifelse(input$show_ylab, input$feature, ""),
      col = "blue",
      space = 1,
      ylim = range(pretty(c(0, mydata[[input$feature]]))) # set a range for y-axis
    )
  })  
  
  # sum up the selected columns to be shown in the bar plot based on region
  sum_column <- c("Population","Area (sq. mi.)","Total COVID-19 Cases", "Total COVID-19 Deaths","Total COVID-19 Recovered")
  
  # create a vectors of colors
  mycols = c("tan", "orange1", "magenta", "cyan", "red", "sandybrown", "darkblue", "beige", "coral", "deeppink", "green")
  
  # use pipe to select wanted column and sum up
  mydata2 = mydata%>%group_by(Region)%>%summarise_at(sum_column,sum)
  
  # create a bar plot based on region
  output$plot2 <- renderPlot({
    par(mar=c(6, 12, 3, 3))
    barplot(mydata2[[input$feature2]],
            main = ifelse(input$show_title,paste("Histogram of", input$feature2, "based on region"), ""),
            xlab = ifelse(input$show_xlab,input$feature2, ""),
            xlim = range(pretty(c(0, mydata2[[input$feature2]]))),
            horiz = TRUE,   # create horizontal bar plot
            las = 1,        # so that the labels are always horizontal
            col = mycols,   # use different colors to represent different regions
            names.arg = mydata2$Region
    )
  })
  
  # eliminate non-numeric arguments for scatter plot
  mydata3 <- mydata[,-c(1,2)] 
  
  # create a scatter plot for 2 variables only
  output$scatterPlot <- renderPlot({
    pairs(
      mydata3[c(input$feature3, input$feature4)],
      col = "red",
      pch = 12,
      labels = c(input$feature3, input$feature4),
      main = "Pairs Plot"
    )
  })
}

shinyApp(ui = ui, server = server)
