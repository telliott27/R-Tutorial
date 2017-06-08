library(QCA)
library(dplyr)

# Use mtcars
data(mtcars)
head(mtcars)

# calibrate outcome set
mtcars$mpg.qca<-calibrate(mtcars$mpg,type = "fuzzy", thresholds = c(15,20,30))

# calibrate three condition sets
mtcars$cyl.qca<-calibrate(mtcars$cyl,type="crisp",thresholds = 7)
mtcars$wt.qca<-calibrate(mtcars$wt,type="fuzzy",thresholds = c(2,3,4))
mtcars$hp.qca<-calibrate(mtcars$hp,type="fuzzy",thresholds = c(100,150,200))

# generate truth table
truth<-truthTable(mtcars, outcome="mpg.qca", conditions=c("cyl.qca","wt.qca","hp.qca"),
                  incl.cut1=0.8, sort.by="incl")
truth

# produce solutions
complex<-eqmcc(truth,details=TRUE)
complex

pars<-eqmcc(truth,include="?",details=TRUE)
pars

inter<-eqmcc(truth,include="?",dir.exp=c(0,0,0),details=TRUE)
inter