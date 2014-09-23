##
##	Plot runtime distribution
##
##


plotRuntimeDistribution <- function(data, number, group, abs.y.scale) 
{
	# Check for incomplete runs
	df.comp <- data[!is.na(data$Aeg.Result), ]

	# Set plot limits 
  binwidth=5*60
	min.hour <- floor(min(df.comp$Aeg.Result)/60^2)
	max.hour <- ceiling(max(df.comp$Aeg.Result)/60^2)
	
    # Find max binned count for y limit in plot
	max.count <- with(
    hist(df.comp$Aeg.Result, breaks=c(seq(min.hour*60^2, max.hour*60^2, binwidth))), 
    max(counts))
    y.max <- ceiling(1.05*max.count) # adjust for highest count

    # For labeling breaks 
	breaks <- c(min.hour:max.hour)*60^2
	labels <- formatSeconds(breaks)

	# Subset data
	df <- df.comp[df.comp$Vkl.Cat %in% group, ]

	p <- ggplot(data=df, aes(x=Aeg.Result)) + 
		geom_histogram(colour="black", fill="gray50", binwidth=binwidth) + 
		scale_x_continuous(limits=c(min.hour*60^2, max.hour*60^2), breaks=breaks, labels=labels) + 
		labs(x="Result", y="Runners") #+
	#theme_bw()

	# Set absolute y scale limit
	if (abs.y.scale) { 
		p <- p + scale_y_continuous(limits=c(0, y.max))
	}
	
	return(p)
}  
  
  