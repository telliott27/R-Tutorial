library(dplyr)
library(tidyr)

#set the random seed so we produce the same values
set.seed(24601)

#########################################################
# Append
#########################################################

#create some random data frames
df1<-data.frame(A=sample(1:10,30,replace=T),B=sample(1:30,30,replace=T))
df2<-data.frame(B=sample(20:30,10,replace=T),A=sample(50:60,10,replace=T))
df3<-data.frame(C=sample(100:150,30,replace=T),D=sample(200:300,30,replace=F))

# bind rows
# bind_rows() will bind rows matching up column names, so even if the columns aren't in the same
# order, they will still match up
df.new<-bind_rows(df1,df2)
print(df.new,n=Inf)

# if there is a column that doesn't match, then that column will be filled in with missing values
df.new<-bind_rows(df1,df3)
print(df.new,n=Inf)

# Binding columns appends columns with no effort to match rows
df.new<-bind_cols(df1,df3)
print(df.new,n=Inf)

# Binding columns will fail if the number of rows do not match
#df.new<-bind_cols(df1,df2)

?bind_rows

#########################################################
# Merge
#########################################################

#create some random data frames
df1<-data.frame(id=c(1:10),A=sample(1:10,10,replace=T),B=sample(1:30,10,replace=T))
df2<-data.frame(id=c(6:15),C=sample(20:30,10,replace=T),D=sample(50:60,10,replace=T))
df3<-data.frame(id=c(10:1),E=sample(100:150,10,replace=T),F=sample(200:300,10,replace=F))

# inner join only keeps rows that match in both data frames
df.new<-inner_join(df1,df2,by="id")
df.new

# left join keeps all rows from the first data frame, and matching
# rows from the second. Rows in the second that don't match
# are discarded
df.new<-left_join(df1,df2,by="id")
df.new

# left join keeps all rows from the second data frame, and matching
# rows from the first. Rows in the first that don't match
# are discarded
df.new<-right_join(df1,df2,by="id")
df.new

# full join returns all rows from both data sets
df.new<-full_join(df1,df2,by="id")
df.new

# semi join returns all rows from the first data frame that
# match with rows in the second data frame, and only
# the columns from the first data frame. This functions much
# like a filter, filtering out rows that don't exist in
# the second data frame.
df.new<-semi_join(df1,df2,by="id")
df.new

# anti join returns rows in the first data frame that do not match
# in the second data frame, returning only columns from the first.
# This is like the opposite of the semi join.
df.new<-anti_join(df1,df2,by="id")
df.new

#########################################################
# Contract & Collapse
#########################################################

data(mtcars)
head(mtcars)

# count will generate counts based on groups defined by supplied variables
# this is basically the same as the default behavior of contract
count(mtcars,cyl)

# you can supply more than one variable
# count will generate counts based on combinations of the variables
count(mtcars,cyl,gear)

?count

# To recreate collapse, use group_by then summarize
mtcars.cyl<-group_by(mtcars,cyl)
# group by doesn't actually change the data set, just adds an atribute that defines how to group
# subsequent dplyr operations
mtcars.cyl
# now when we summarize, it will summarize over the group we defined
mtcars.cyl<-summarize(mtcars.cyl,mpg=mean(mpg))
mtcars.cyl

# we can create multiple summary statistics
mtcars.cyl<-group_by(mtcars,cyl)
mtcars.cyl<-summarize(mtcars.cyl,mpg=mean(mpg),hp=mean(hp),count=n())
# n() when used inside summarize returns the number of rows in the group
mtcars.cyl

?summarize

# Use summarize_each to perform the same function across multiple variables
mtcars.cyl<-group_by(mtcars,cyl)
mtcars.cyl<-summarize_each(mtcars.cyl,funs(mean),mpg,disp:carb)
mtcars.cyl

?summarize_each

#########################################################
# Reshape
#########################################################

# reshape functions are found in the tidyr package
browseVignettes("tidyr")

# generate some data
set.seed(24601)
mydata<-data.frame(year=rep(c(2000:2010),times=2),
                   sex=c(rep("male",length.out=11),rep("female",length.out=11)),
                   income=sample(20000:50000,size=22,replace=T))

# use spread to reshape wide
mydata
mydata.wide<-spread(mydata,sex,income)
mydata.wide

# use gather to reshape long
mydata.long<-gather(mydata.wide,sex,income,female,male)
mydata.long
