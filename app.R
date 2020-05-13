library(shiny)
library(shinyWidgets)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    tags$head(tags$style(
        HTML('
         #sidebar {
            background-color: #a7bbc4;
         }


        ')
    )),
    # Header or title Panel 
    titlePanel('A Histogram with mtcars Dataset'),
    
    # Sidebar panel
    sidebarPanel(id="sidebar",
        selectInput("var",
                    label = "1. Select the quantitative Variable", 
                    choices = colnames(mtcars)), 
        sliderInput("bin",
                    "2. Select the number of histogram BINs by using the slider below",
                    min=10,
                    max=50,
                    value=25),
        radioButtons("color",
                     label = "3. Select the color of histogram",
                     choices = c("Green", "Red","Yellow","Blue","Orange"),
                     selected = "Red"),
        textInput(inputId = "title",
                  label = "4. Write a title for the histogram",
                  value = "Histogram of Mtcars Datasets"),
        actionButton(inputId = "gotitle",
                     label = "Update Title"),
    ),
    setBackgroundColor(
        color = c("#F7FBFF", "#2171B5"),
        gradient = "linear",
        direction = "bottom"
    ),
    mainPanel(
        h4("Histogram"),
        plotOutput("myhist"),
        h4("Summary"),
        verbatimTextOutput("stats"))
    
    
)

# Define server logic required to draw a histogra form
server <- function(input, output) {
    
    rv<-reactiveValues(change="Histogram of Mtcars Datasets")
    observeEvent(input$gotitle, { rv$change <- input$title })
    
    output$myhist <- renderPlot({
        hist(mtcars[,input$var],
             col =input$color,
             xlim = c(0, max(mtcars[,input$var])),
             main = rv$change,
             breaks = seq(0, max(mtcars[,input$var]),l=input$bin+1),
             xlab = names(mtcars[input$var]))
    })
    output$stats <- renderPrint({
        summary(mtcars[,input$var])
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
