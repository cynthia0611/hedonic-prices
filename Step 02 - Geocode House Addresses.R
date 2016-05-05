
# setwd( "C:/Users/jdlecy/Documents/GitHub/hedonic-prices" )

source( "Step 01 - Load Housing Data.R" )

houses <- dat[ , c("address","zip") ]

# remove comma and period from address variable
houses$address <- gsub( ",", "", houses$address )
houses$address <- gsub( "\\.", "", houses$address )

addresses <- paste( houses$address, "Syracuse, NY", houses$zip, sep=", " )

head( addresses )


library( ggmap )


# translate street address to latitude longitude coordinates
#
# lat.long <- geocode( addresses )
#
# takes about 5 min to run



# pre-geocoded version of dataset for demo

lat.long <- read.csv( "Data/lat.long.csv" )

head( lat.long )





syracuse <- get_map(  
                      location='syracuse, ny', 
                      zoom = 12, 
                      color="bw"
                    ) 



syr.map <- ggmap( 
                  syracuse, 
                  extent = "device"                    
                ) 


                  

# The point geom is used to create scatterplots.

syr.map + geom_point( 
                      data=lat.long, #a data frame
                      aes(x=lon, y=lat), 
                      #define aesthetic mapping
                      #how variables in the data mapped to visual properties
                      size=2, 
                      col="red", 
                      alpha=1   #transparent level, .1~1, 1 means solid  
                    ) 


dat <- cbind( dat, lat.long )

rm( houses )
rm( addresses )
