source("createVolcano.R");
source("modifyList2.R");

# initializing the server
shinyServer(function(input, output) {

# fetching the input data
  input.data <- reactive({

    inFile <- input$file1
    if (is.null(inFile)) return(NULL)

    dataframe <- read.csv(
		inFile$datapath,
		header=input$header,
		sep=input$sep,
		quote=input$quote
		)
   })

#  usegroups <- reactive({ input$groups })

# arguments coming from the user's input thru ui.R
  volcano.args <- reactive({

#    colour.scheme <- unlist(strsplit(input$colour, ';'))
#    colour.scheme <- gsub("^\\s+|\\s+$", "", colour.scheme)
 #   use.colour <- ifelse(colour.scheme %in% colours(), colour.scheme, 'black');

    list(
    #  xybias = input$xybias,
	  condA = input$condA,
	  condB = input$condB,
	  label.size = input$labelsize,
	  threshold = input$threshold,
    geneLabel = input$geneLabel,
#      pr.threshold = rescale(input$threshold, to=c(0.93,1), from = c(0,1)),
      point.size.range = input$range,
      xlabel = input$xlabel,
      ylabel = parse(text=strsplit(input$ylabel, ',')),
      #scheme = use.colour,
      draw.signif.line = input$signif
     # add.jitter = input$jitter,
      #jitter.factor = input$jitter.factor
    )
  })

# creating volcano plot
output$volcano <- renderPlot({

	dat <- input.data();

# setting the formal arguments of a function
	volcano.defaults <- formals(createVolcano);

	volcano.args.in  <- modifyList2(volcano.defaults, volcano.args())
    formals(createVolcano) <- volcano.args.in;
	
	# if no data, plot nothing
	if(is.null(dat)) return(NULL);
	plot(createVolcano(
#		x=dat[,2],
#		y=dat[,3],
		dat=dat
		))
    #p <- ggplot(dat, aes_string(x=dat[,2], y=dat[,3])) + geom_point()
    
    #print(p)
    
  }, height=700,width=800)









# creating table view
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects and uploads a 
    # file, it will be a data frame with 'name', 'size', 'type', and 'datapath' 
    # columns. The 'datapath' column will contain the local filenames where the 
    # data can be found.
    dat <- input.data();
    if(is.null(dat)) return(NULL);
    head(dat);
  })

# creating histogram
  output$histogram <- renderPlot({
    dat <- input.data();
    if(is.null(dat)) return(NULL);
    hist(x=dat[,10],main="Histogram of unadjusted p-values", xlab = "p-value");
	})















# downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
 
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste(input$dataset, input$filetype, sep = ".")
    },
 
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")

      dat <- input.data();

# setting the formal arguments of a function
  export.defaults <- formals(exportDat);

  export.args.in  <- modifyList2(export.defaults, volcano.args())
  formals(exportDat) <- export.args.in;
  
  # data switching based on the user's input
  manualDat=exportDat(dat=dat,switch="manual")
  threshDat=exportDat(dat=dat,switch="thresh")

    # Fetch the appropriate data object, depending on the value
    # of input$dataset.
    dataWrite <- switch(input$dataset,
          "Manual Genes" = manualDat,
          "Threshold Genes" = threshDat
          )

      # Write to a file specified by the 'file' argument
      write.table(dataWrite, file, sep = sep,row.names = FALSE)
    }
  )
})