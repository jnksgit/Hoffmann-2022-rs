################################################################

# Preprocess the bexis data and run Moran's I

################################################################
install.packages("ape", dependencies = T)
install.packages("geoR", dependencies = T)
install.packages("readx1", dependencies = T)
library(ape)
library(geoR)
library(readxl)
library(sp)
library(nlme)

setwd('C:/Users/Janny/Desktop/SEBAS/Bexis/Bexis_BiomDiversity_Model')
dir()
BexisRaw <- read.csv("/Users/janikhoffmann/Desktop/SeBAS/model_parameters_moran.csv")
str(BexisRaw)

#############################################################################################################
######################################    DATA EXPLORATION    ###############################################
#############################################################################################################

#Change names and fields as numeric when needed
Bexis6 <- data.frame(
  Exploratory   = BexisRaw$explo,
  EP            = BexisRaw$explo,
  x             = BexisRaw$x,
  y             = BexisRaw$y,
  DBH_sd        = BexisRaw$DBH_sd,
  h_sd          = BexisRaw$h_sd,
  BA            = BexisRaw$BA,
  SDI           = BexisRaw$SDI,
  H             = BexisRaw$H,
)
str(Bexis6)

##################   BIOMASS ########################

#Are there NAs in biomass?
is.na(Bexis6$biomass)   
sum(is.na(Bexis6$biomass))
colSums(is.na(Bexis6))

# Remove missing values:
Bexis7 <- subset(Bexis6, biomass != "NA")
#Bexis7 <- subset(Bexis6, Rich != "NA")

# We can check for spatial autocorrelation within exploratories as well.
# Bexis7 <- subset(Bexis8, explo == 'ALB')

#Select columns to build distance matrix (x, y and study variable)
BexisDBH_sd <-Bexis7[c(3,4,5)]
str(BexisDBH_sd)
DBH.dist <-as.matrix(dist(cbind(BexisDBH_sd$x, BexisDBH_sd$y)))
DBH.dist.inv <- 1/DBH.dist

#If we used several samples from same site we might get infinite values in the matrix we have to remove
DBH.dist.inv[is.infinite(DBH.dist.inv)] <- 0

# replace diagonals of the matrix with 0
diag(DBH.dist.inv) <- 0

# Show first 5 rows/cols
DBH.dist.inv[1:5, 1:5]

# Apply Moran's I

# Moran's I is the slope of the line that best fits the relationship between 
# neighboring values and each observation.

# https://desktop.arcgis.com/en/arcmap/10.3/tools/spatial-statistics-toolbox/spatial-autocorrelation.htm

# If the observed value of I is significantly greater than the expected value, 
# then the values of x are positively autocorrelated, 
# whereas if Iobserved <<< Iexpected, this will indicate negative autocorrelation.

# H null is that there is no spatial autocorrelation and that the distribution is random
MoranI<-Moran.I(BexisDBH_sd$DBH_sd, DBH.dist.inv, na.rm=TRUE)
MoranI

# To estimate whether Moran's I is significantly different, we use the z score
ZI <- (MoranI$observed - MoranI$expected)/sqrt(MoranI$sd)
ZI

# -1.65 < ZI < 1.65, therfore there is a high chance that the  pattern is random
# we accept H null of data being spatially random