##
##		Scrape finish times and other data from results website
##

library(XML)
library(plyr)


km.html <- readLines("http://www.championchip.ee/ftp/liveresults/2014/140914_42km/")
km.doc <- htmlParse(km.html)

km <- readHTMLTable(km.doc, header=T, as.data.frame=F, skip.rows=1)
km <- km[[1]]
km <- data.frame(km, stringsAsFactors=F)

# The last row is blank, we accidentally catch the footer as a row.
km <- km[-nrow(km), ]
km <- km[, -18]

# they changed the format, it is all on one page now
# for (i in 2:4) {
# 	url <- paste0("http://www.championchip.ee/ftp/liveresults/2014/140914_42km/index", i, ".htm")
# 	cat(paste0(url, "\n"))
# 	res.html <- readLines(url)
# 	res.doc  <- htmlParse(res.html)

# 	res <- readHTMLTable(res.doc, header=T, as.data.frame=F, skip.rows=1)
# 	res <- res[[1]]
# 	res <- data.frame(res, stringsAsFactors=F)

# 	# Remove last row (NA)
# 	res <- res[-nrow(res), ]

# 	# Add to previous pages
# 	km42 <- rbind(km42, res)
# }

for (i in c(1, 2, 3)) { 
	km[, i] <- as.numeric(km[, i]) 
}
for (i in c("Riik.Nat", "Klubi.Club", "Vkl.Cat")) {
	km[, i] <- as.factor(km[, i])
}

km[, "Aeg.Result"] <- hms(km[, "Aeg.Result"])
km[, "Aeg.Result"] <- as.duration(km[, "Aeg.Result"])  # no worries about the warning

# Take out two finishers with extreme times
long <- km$Aeg.Result > 7*3600 & !is.na(km$Aeg.Result)
km[long, ]
km <- km[!long, ]

km42 <- km


##
##		21km data
##

km.html <- readLines("http://www.championchip.ee/ftp/liveresults/2014/140914_21km/")
km.doc <- htmlParse(km.html)

km <- readHTMLTable(km.doc, header=T, as.data.frame=F, skip.rows=1)
km <- km[[1]]
km <- data.frame(km, stringsAsFactors=F)

# The last row is blank, we accidentally catch the footer as a row.
km <- km[-nrow(km), ]
km <- km[, -18]

for (i in c(1, 2, 3)) { 
	km[, i] <- as.numeric(km[, i]) 
}
for (i in c("Riik.Nat", "Klubi.Club", "Vkl.Cat")) {
	km[, i] <- as.factor(km[, i])
}

km[, "Aeg.Result"] <- hms(km[, "Aeg.Result"])
km[, "Aeg.Result"] <- as.duration(km[, "Aeg.Result"])  # no worries about the warning

km21 <- km

##
##		10km data
##

km.html <- readLines("http://www.championchip.ee/ftp/liveresults/2014/140914_10km/")
km.doc <- htmlParse(km.html)

km <- readHTMLTable(km.doc, header=T, as.data.frame=F, skip.rows=1)
km <- km[[1]]
km <- data.frame(km, stringsAsFactors=F)

# The last row is blank, we accidentally catch the footer as a row.
km <- km[-nrow(km), ]
km <- km[, -18]

colnames(km)[c(1, 3, 5:7, 9)] <- c("Koht.Pos", "Nr.Bib", 
	"Riik.Nat", "Klubi.Club", "Aeg.Result", "Vkl.Cat")
for (i in c(1, 2, 3)) { 
	km[, i] <- as.numeric(km[, i]) 
}
for (i in c("Riik.Nat", "Klubi.Club", "Vkl.Cat")) {
	km[, i] <- as.factor(km[, i])
}

km[, "Aeg.Result"] <- hms(km[, "Aeg.Result"])
km[, "Aeg.Result"] <- as.duration(km[, "Aeg.Result"])  # no worries about the warning

km10 <- km

##	Save all three run times in one file
##

save(km42, km21, km10, file="data/run_times.rda")



