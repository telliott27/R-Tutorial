sink(file="week5-R.log",split=TRUE)
#######################################
# Week 4 & 5
#######################################

#######################################
# Variables
#######################################

# there are four basic types of variable types

x.char<-"character"
class(x.char)

x.num<-3
class(x.num)

x.complex<-3+2i
class(x.complex)

x.bool<-TRUE
class(x.bool)

# Naming variables:
# names can contain letters, numbers, period, and under score.
# names cannot begin with a number or an underscore
# names can begin with a period and then a letter, a period and another period, 
# but not a period and then a number
# naming a variable beginning with a period will hide it from ls()

.dv<-c(1,2,3,4)

ls()

.dv

# Try to name a variable in an inconsistent way

# 2nd<-3
# .7even<-77
# _merge<-c(1,1,1,2,3,3,3,3,3,3,3,3,3)

# variables are case sensitive

sex<-"female"
Sex<-"male"
SEX<-"Woman"

ls()

# It is common to use the period where other languages might use the under score

African.America<-TRUE


rm(list=ls())
#######################################
# Factor
#######################################

# Factors store categorical variables

sex<-c("male","male","female","male","female","female")
sex<-factor(sex)

sex

# The underlying values are stored as numbers, with value labels on top
unclass(sex)

?factor

x<-c(0,6,12,3,5,99)
x<-factor(x)

# Even if original values are numbers, numbers are converted into
# characters for the value labels and new numbers are used for
# underlying values
x
unclass(x)

# Boolean comparisons are done on value labels, NOT underlying values
# R will automatically convert numbers into characters when
# comparing with factors
x==6

x=="6"

# 2 appears in underlying values, but not in value labels, so
# this will evaluate to FALSE for all values
x==2

# You can tell R which levels SHOULD appear, and the labels for those levels
OS<-c(1,1,1,2,4,1,2,1,1,4,4,4,2,2,2,1,4,2,1)
OS<-factor(OS,levels=c(1,2,3,4),labels=c("Windows","Mac","Linux","Other"))

summary(OS)

OS

# Ordered variables

ses<-c("low","high","mid","mid","high","mid","mid","low","low","mid")

# Ordered variables preserve the order of the levels. It is a 
# good idea to supply the levels= argument
ses.o<-ordered(ses,levels=c("low","mid","high"))
ses.o

# You can also create an ordered variable by supplying the
# ordered=TRUE argument to factor()
ses.f<-factor(ses,levels=c("low","mid","high"),ordered=TRUE)
ses.f

# Dummy variables from Factors

# Booleans are converted into 0, 1 when coerced into a numeric
(OS=="Windows")*1

# Composite Categorical Variables

# We can combine two different factor variables to create a third, composite variable

data(mtcars)

mtcars$cyl<-factor(mtcars$cyl)
mtcars$gear<-factor(mtcars$gear)

# Use interaction() to create the composite variable
mtcars$cyl.gear<-interaction(mtcars$cyl,mtcars$gear)
mtcars[1:10,c("cyl","gear","cyl.gear")]

summary(mtcars$cyl.gear)

?interaction

#######################################
# Recoding Continuous Into Categorical
#######################################

# Use cut() to code continuous variables into categorical
# cut() returns a factor variable

mtcars$mpg.cat<-cut(mtcars$mpg,breaks=c(-Inf,18,25,Inf),
                    labels=c("Low","Mid","High"))
mtcars[1:10,c("mpg","mpg.cat")]

?cut


#######################################
# Data Frames
#######################################

# Data frames are objects that contain data sets
# each column can be any variable type
# columns can also contain more complex objects (but this gets confusing)

mydata<-data.frame(a=1:3,b=4:6)
anotherdf<-data.frame(c=7:9,d=10:12)
mydata$aDF=anotherdf
mydata$aArray=array(c(1:27),dim=c(3,3,3))

mydata

names(mydata)

sapply(mydata,class)

# so generally avoid making columns more complex objects

# Accessing rows and columns

data("mtcars")

mtcars

# identify the 2nd column in the first row
mtcars[1,2]

# identify the eighth row in the fourth column
mtcars[8,4]

# print out the third row
mtcars[3,]

# print out the fourth column
mtcars[,4]

# print out the fourth column as a column
mtcars[,4,drop=FALSE]

# print rows 4 through 10
mtcars[4:10,]

# print out the first three columns
mtcars[,1:3]

# combine the last two
mtcars[4:10,1:3]

# select certain rows
mtcars[c(1,4,6,7,10),]

# can also use $ to select columns
mtcars$mpg

# can use $ to create new columns
mtcars$new.var<-c(1:32)
mtcars

# can assign values to subset
mtcars$new.var[6:15]<-c(101:110)
mtcars

# Drop, Keep, Filter

# can drop a variable by using the minus sign
mtcars[,-3]

# can drop rows the same way
mtcars[-c(1:10),]

# output the names of variables:
names(mtcars)
mtcars[,names(mtcars)!="mpg"]

# use booleans to select cars with 4 cyl
mtcars[mtcars$cyl==4,]

# renaming variables

# rename variables by modifying the object returned by names()
names(mtcars)
names(mtcars)[12]<-"my.var"
names(mtcars)

# Getting summary stats for all variables:
summary(mtcars)

# Show structure of data (similar to describe)
str(mtcars)

#######################################
# Dplyr
#######################################

# remember to install dplyr if you haven't done that already
# install.packages("dplyr")
library(dplyr)

# use select to keep and drop variables
?select
select(mtcars,-mpg)

select(mtcars,cyl:drat)

# use filter to filter out rows
filter(mtcars,cyl==4)

filter(mtcars,mpg>30)

# Notice: dplyr does not keep row names - lots of reasons for this, see dplyr
# vignettes for their reasons
# can save row names to a variable with add_rownames
mtcars2<-add_rownames(mtcars,"car")
mtcars2

# Notice also that dplyr adds a wrapper class to the normal data.frame which modifies
# how it is printed to the console. This USUALLY doesn't cause problems, but you can
# remove the tbl class with as.data.frame
as.data.frame(mtcars2)

# Rename column names with rename()
rename(mtcars2,model=car)

#######################################
# Importing Data
#######################################

# We've already imported CSV files
# R has a pre-installed package called foreign that imports data
# from other Stats programs (Stata, SPSS, SAS)
library(foreign)
?read.dta
?read.spss
?read.ssd

# Unfortunately, foreign has stopped updating the read.dta function for 
# Stata files after Stata 12. To import Stata 13 files, you can install a third
# party package readstata13, which has read.dta13(). 
# For Stata 14 files, you can try installing the package
# haven and use read_dta(), though it is a little buggy

# R doesn't have a built in function to import directly from Excel files
# But there are a variety of packages you can install from CRAN
# One of these is readxl
library(readxl)
?read_excel




sink(NULL)