
library(ggplot2)
library(lubridate)

options(lubridate.verbose = FALSE)

# Load marathon results
# This was generated with helpers/get_data.R
load("data/run_times.rda")

# Function for plotting
source("helpers/plotRuntimeDistribution.R")
source("helpers/formatSeconds.R")
source("helpers/markRunner.R")

# Aggregate groups for all, all men, all women
all.groups <- levels(km42$Vkl.Cat)
all.men    <- all.groups[grep("^M", all.groups)]
all.women  <- all.groups[grep("^N", all.groups)]

# Main server function, this is called every time user input changes
shinyServer(
	function(input, output) {
		output$histogram <- renderPlot({
			# Group, i.e. age group, male/female
			group <- switch(input$group, "All"=all.groups, "Men"=all.men, "Women"=all.women, 
			"Men's youth"="MN", "Men 18-39"="M", "Men 40-44"="M 40", 
			"Men 45-49"="M 45", "Men 50-54"="M 50", "Men 55-59"="M 55", 
			"Men 60-64"="M 60", "Men 65-69"="M 65", "Men 70+"="M 70", 
			"Women's youth"="NN", "Women 18-39"="N", "Women 40-44"="N 40", 
			"Women 45-49"="N 45", "Women 50-54"="N 50", "Women 55-59"="N 55", 
			"Women 60-64"="N 60", "Women 65-74"="N 65", "Women 75+"="N 75")

			# Get right data frame for run distance
			# Pass all of it, the function will subset for groups but needs whole
			# frame to get constant plot limits.
			distance <- switch(input$distance, "Marathon"="km42", 
				"Half-marathon"="km21", "10k"="km10")
			data <- get(distance)
			
			p <- plotRuntimeDistribution(data, group=group, 
				abs.y.scale=input$abs.y.scale)

			# Annotate with results for specific runner
			number <- input$number

			p <- markRunner(data, number, group, histplot=p)

			print(p)
		})
	}
)



