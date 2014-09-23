##
##	Format duration in seconds for display
##
##	Format numeric that contains a duration <24 hrs in seconds for hh:mm:ss 
##	display. 
##

formatSeconds <- function(x) {
	# Check <24h
	if (max(x) > (24*3600)) { stop("x greater than 24 hours.") }
	# Format runtime in seconds for display
	x <- as.period(as.duration(x))
	hh <- sprintf("%02i", x@hour)
	mm <- sprintf("%02i", x@minute)
	ss <- sprintf("%02i", x@.Data)
	x <- paste(hh, mm, ss, sep=":")
	return(x)
}