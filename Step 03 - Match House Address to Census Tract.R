
# setwd( "C:/Users/jdlecy/Documents/GitHub/hedonic-prices" )

source( "Step 02 - Geocode House Addresses.R" )


### MATCH GEOCODED ADRESSES TO A CENSUS TRACT

# to add census data we need to associate a house with a census tract

# use census API:

# # https://transition.fcc.gov/form477/censustracts.html


require( RCurl )


tract.id <- NULL

for( i in 1:nrow(lat.long) )
{

	print( i )
	
	aURL <- paste( "http://data.fcc.gov/api/block/2010/find?latitude=",
	               lat.long$lat[i],"&longitude=",lat.long$lon[i], sep="" )

	x <- getURL( aURL )

	start.here <- regexpr( "Block FIPS", x )
	# 	regexec(pattern, text, ignore.case = FALSE,
	# 	        fixed = FALSE, useBytes = FALSE)
	
	#   regexpr returns an integer vector of the same length as text giving the starting position
	#   of the first match or -1 if there is none, with attribute "match.length", an integer 
	#   vector giving the length of the matched text (or -1 for no match). The match positions 
	#   and lengths are in characters unless useBytes = TRUE is used, when they are in bytes. 
	#   If named capture is used there are further attributes "capture.start", 
	#   "capture.length" and "capture.names".
	
	this.one <- substr( x, (start.here+12), (start.here+26) )
	
	# Extract or replace substrings in a character vector.
	# substr(x, start, stop)
	
	# Block FIPS:360670040001007  
	# 36=state, 067=county, 004000=census.tract 1007=block.group
	
	tract.id[i] <- substr( this.one, 6, 11 )
	
}

# combine house data with lat lon coordinates and census tract IDs

dat <- cbind( dat, tract.id )

rm( tract.id )

