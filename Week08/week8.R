sink(file="week8-R.log",split=TRUE)
#######################################
# Week 8 Functions and Loops
#######################################


#######################################
# Functions
#######################################

# functions are defined much like other objects
# arguments can be assigned default values. This 
# makes the argument optional.
recode.missing<-function(x,recode=0) {
  x[which(is.na(x))]<-recode
  return(x)
}
my.vector<-c(1,3,NA,6,5,NA)
recode.missing(my.vector)

# we can supply a value for the recode argument
# to alter what missing values get recoded to
recode.missing(my.vector,-99)

# functions have their own internal (or local)
# environments. Creating a variable within
# a function will not create the variable
# in the global environment.
myfunc<-function(x) {
  y<-x+3
  return(y)
}
ls()
myfunc(6)
ls()

# However, functions can access variables in 
# the global environment. However, this can
# cause unexpected results, so don't do it.
myfunc<-function(x) {
  z<-x+y
  return(z)
}
x<-4
y<-3
z<-78
myfunc(6)
z

# you can allow the function to accept any number of arguments with
# the ... special character in the arguments definition
mysum<-function(...) {
  thevalues<-list(...)
  thevalues<-unlist(thevalues)
  thesum<-sum(thevalues)
  return(thesum)
}
mysum(1,2,3,4,5,6,7,8)


# the ... special character can be combined with
# named arguments
mysum<-function(...,na.rm=TRUE) {
  thevalues<-list(...)
  thevalues<-unlist(thevalues)
  thesum<-sum(thevalues,na.rm=na.rm)
  return(thesum)
}
mysum(1,2,3,NA,5,6,7,8)
mysum(1,2,3,NA,5,6,7,8,na.rm=FALSE)


#######################################
# Loops
#######################################

# for loops iterate over a sequence
for(i in c(1:5) ) {
  print(i)
}

# the sequence can be any vector-like object
for(i in c(5:10) ) {
  print(i)
}
# in any order
for(i in c(5,2,8,3,4)) {
  print(i)
}

# for loops can be used to create new variables
# algorithmically
data(mtcars)
for( i in unique(mtcars$cyl) ) {
  mtcars[[paste0("cyl_",i)]]<-(mtcars$cyl==i)*1
}
?paste

# or to create new objects 
for( i in unique(mtcars$cyl) ) {
  df<-mtcars[mtcars$cyl==i,]
  df.name<-paste0("mtcars.cyl",i)
  assign(df.name,df)
}
?assign

for( var in c("cyl","mpg","wt")) {
  print(mtcars[,var])
}


# While Loops
# while loops repeatedly run until an expression
# evaluates to false
x<-0
while( x<5 ) {
  print(x)
  x<-x+1
}

# Bubble Sort
x<-sample(10)
x
sorted<-FALSE
while( !sorted ) {
  anyFlips<-FALSE
  for(i in c(2:length(x)) ) {
    if ( x[i-1] > x[i] ) {
      anyFlips<-TRUE
      a<-x[i-1]
      b<-x[i]
      x[i-1]<-b
      x[i]<-a
    }
  }
  if( !anyFlips ) sorted<-TRUE
}
x


# Apply functions iterate over an object
# repeatedly evaluating a function and returning
# the results. Apply functions are more limited
# in what they can do than loops, but are substantially
# faster.

# apply() iterates over margins of an array
x<-matrix(sample(16),nrow=4)
x
apply(x,1,sum) # calculate row sums
apply(x,2,sum) # calculate column sums

# lapply() iterates over a list, returning a list of the
# same length
x<-list()
for(i in 1:5) {
  x[[i]]<-runif(10,min=10,max=100)
}
lapply(x,mean)

# sapply() iterates over a list, returning a vector
# matrix, or array, whatever is simpliest and can
# properly store the results of the apply.
sapply(x,mean)

sink(NULL)
