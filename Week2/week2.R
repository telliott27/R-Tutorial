###############
# Week 2
###############
# 2016-01-20

###############
# Finding Help
###############

# You can look up help with ?
?sum

# An equivalent way to find help is
help("sum")

# If you don't know the name of the function you can search help files with
??regression

# Equivalently
help.search("regression")

# You can access Vignettes with
vignette("rotated",package="grid")

# You can browse all available vignettes in a package:
browseVignettes("grid")

###############
# Saving and Loading Data
###############

# import some data from csv 
nd.congress<-read.csv("nd_congress.csv")
# lots of options for importing from csv files
# we'll talk more about importing later
?read.csv

# create new vector from one of the columns
senate<-nd.congress$Total.Senate

# save everything in our environment
save.image("week2.Rdata")
# lots of options to change how things are saved
# including format, compression, older versions
?save.image

# save select objects from our environment
save(nd.congress,file="nd_congress.Rdata")

# clear our environment
rm(list=ls())

# load up the nd.congress dataset we just saved
load("nd_congress.Rdata")
