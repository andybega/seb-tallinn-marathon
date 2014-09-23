##
##		Annotate runner results
##
##

markRunner <- function(data, number, group, histplot) {

	require(grid)
	p <- histplot

	# Subset by group, we will need this for ranking and percentile
	df <- data[data$Vkl.Cat %in% group & !is.na(data$Aeg.Result), ]

	# Check if number is valid
	if (!is.na(number)) {
		if (!number %in% data$Nr.Bib) {
			grob.text <- "Invalid start number"
		} else if (is.na(data[data$Nr.Bib==number, "Aeg.Result"])) {
			grob.text <- paste0(number, " did not finish")
		} else {
			# Add line for finish time
			my.time <- data[data$Nr.Bib==number, "Aeg.Result"]
			my.time <- as.numeric(my.time)	

			label.text <- paste0("Result: ", formatSeconds(my.time))

			df.mytime <- data.frame(my.time=my.time)
		
			p <- p + geom_vline(data=df.mytime, aes(xintercept=my.time), color="red", size=2, alpha=0.5)

			# Grop text
			slower <- sum(df$Aeg.Result > my.time)/nrow(df)
			slower <- round(slower*100)
			rank <- sum(df$Aeg.Result < my.time) + 1

			grob.text <- paste0("Finish: ", formatSeconds(my.time), "\nFaster than: ", 
				slower, "%\nRank: ", rank, " of ", nrow(df))
		}

		# Now add text annotation
		my.grob <- grobTree(textGrob(grob.text, x=0.75,  y=0.85, hjust=0,
  		gp=gpar(col="blue", fontsize=15, fontface="plain")))

		# add annotation
		p <- p + annotation_custom(my.grob)
	}

	return(p)
}

