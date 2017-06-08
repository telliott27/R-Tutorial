sink("Week 7 Homework.txt",split=TRUE)
#######################################################
# Week 7 Homework
#######################################################

library(foreign)
library(dplyr)
library(tidyr)

# import DOCA dataset
doca<-read.dta("final_data.dta")

# keep only eventid, year, and smoname1-4
doca<-select(doca,eventid,year=evyy,matches("smoname[1-4]"))
names(doca)

# reshape data to long
doca.long<-gather(doca,smonum,smoname,matches("smoname[1-4]"))

# import pci.csv
pci<-read.csv("pci.csv")

#check dimensions of data frame before merging
dim(doca.long)

#merge on pci
doca.long<-left_join(doca.long,pci,by="year")

# check dimensions after merge
dim(doca.long)

#list out first ten rows
doca.long[1:10,]

sink(NULL)