#Start by installing and loading Shiny of course.
#install.packages('shiny')
library(shiny)

#Tutorial
#runExample("01_hello")

if (! require(GEOquery, quietly=TRUE)) {
  if (! exists("biocLite")) {
    source("https://bioconductor.org/biocLite.R")
  }
  biocLite("GEOquery")
  library(GEOquery)
}

GSE107122 <- getGEO("GSE61989", GSEMatrix =TRUE, AnnotGPL=TRUE)

if (length(GSE107122) > 1) {
  idx <- grep("GPL6244", attr(GSE107122, "names"))
} else {
  idx <- 1
}

GSE107122 <- GSE107122[[idx]]

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Single Cell Transcriptional Profiling"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of samples ----
      sliderInput(inputId = "samples",
                  label = "Number of Samples:",
                  min = 1,
                  max = 12,
                  value = 1),
      
      # Input: Slider for number of features to pull
      sliderInput(inputId = "features",
                  label = "number of features",
                  min = 1,
                  max = 28549,
                  value = 10)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the GSE107122 expression Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    tmp <- GSE107122[1:input$features, 1:input$samples]
    x    <- exprs(tmp)
    bins <- seq(min(x), max(x))
    
    cyclicPalette <- colorRampPalette(c("#00AAFF",
                                        "#DDDD00",
                                        "#FFAA00",
                                        "#00AAFF",
                                        "#DDDD00",
                                        "#FFAA00",
                                        "#00AAFF"))
    
    tCols <- cyclicPalette(13)
    
    hist(x, col = tCols, border = "white",
         xlab = "Number of Samples",
         main = "Histogram of expression for Various Samples of GSE107122")
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)