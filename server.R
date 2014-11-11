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
    hist(x=dat[,3],main="Histogram of unadjusted p-values", xlab = "p-value");
	})

})
