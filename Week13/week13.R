library(QCA)
library(dplyr)

# we will start out using the mtcars data set
data("mtcars")
head(mtcars)

# calibrating fuzzy sets
mtcars$mpg.fuzzy<-calibrate(mtcars$mpg,type="fuzzy",thresholds = c(10,20,30))
head(mtcars[,c("mpg","mpg.fuzzy")])

# QCA comes with some data sets to use as examples. We'll use the data set for Cress and Snow's 2000 AJS article
# on homeless mobilization

data(d.homeless)
head(d.homeless)

# the truthTable function generates a truth table object
truth<-truthTable(d.homeless,outcome="REP",
                  conditions=c("VI","DT","SA","CS","DF","PF"),
                  incl.cut1=0.8,
                  sort.by="incl")
truth #print the truth table

# eqmcc is the function that takes the rows of the truth table coded as having the outcome
# and reduces these rows to simplified solutions

# this generates a complex solution, with no simplifying assumptions
# the details=TRUE forces the function to print the coverage and consistency scores
eqmcc(truth,details=TRUE)

# this generates a parsimonious solution, where remainder rows are included if they help
# produce simpler solutions
eqmcc(truth,details=TRUE,include="?")

# this generates an intermediate solution, where remainder rows are included if they
# help produce simpler solutions but only if it does not drop an expected condition
# from the solution
eqmcc(truth,details=TRUE,include="?",dir.exp=c(1,1,1,1,1,1))
