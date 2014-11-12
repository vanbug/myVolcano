shinyUI(pageWithSidebar(
  headerPanel("Interactive Volcano Plot"),
  sidebarPanel(
    fileInput('file1', 'Choose File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    tags$hr(),
    # data download
    selectInput("dataset", "Choose a dataset to download:", 
                  #choices = c("Rock", "Pressure")),
                choices = c("Manual Genes","Threshold Genes")),
      radioButtons("filetype", "File type:",
                   choices = c("csv", "tsv")),
      downloadButton('downloadData', 'Download'),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c( Tab='\t', Comma=','), 'Tab'),
    radioButtons('quote', 'Quote', c(None='', 'Double Quote'='"', 'Single Quote'="'"), 'Double Quote'),
    tags$hr(),
    sliderInput("threshold", "Threshold", min=0, max=5, value=0, step = 0.25),
    # text box to label and color the gene red
    textInput('geneLabel', "Label Gene", 'Wdr5;Mll2'),
    textInput('condA', "Label for conditionA", 'Enter Text'),
    textInput('condB', "Label for conditionB", 'Enter Text'),
    sliderInput("labelsize", "Label size", min=2, max=10, value=4, step = 1),
    #sliderInput("threshold", "Label print strictness", min=0.0, max=1.00, value=0.5, step = 0.01),
    sliderInput("range", "Point Size Range:", min = 0, max = 7, step = 0.05, value = c(0.25,2.5)),
    checkboxInput('groups', 'Add grouping variable', FALSE),
    textInput('colour', "Colour Scheme", 'red;blue'),
    textInput('xlabel', "Label for X-axis", 'Fold Change'),
    textInput('ylabel', "Label for Y-axis", '-Log[10]'),
    checkboxInput('jitter', 'Jitter', TRUE),
    checkboxInput('signif', 'Show Q-value cut off', TRUE),
    sliderInput("jitter.factor", "Jitter Factor", min=0, max=5,value=1, step = 0.5)
  ),
  # label slider
  # colour
  # x bias
  # y bias
  mainPanel(
    tabsetPanel(
      tabPanel("Volcano Plot", plotOutput(outputId = 'volcano', width = "800px", height = "800px")),
      tabPanel("Histogram", plotOutput(outputId = 'histogram', width = "100%")),
      tabPanel("Data Preview", tableOutput("contents")),
      tableOutput('table')
    )
  )
))
