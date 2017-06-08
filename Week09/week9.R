#######################################
# Week 9 Error Handling
#######################################

#######################################
# Break and Next
#######################################

#break stops a loop completely
for(i in c(1,2,3,4,5)) {
  print(i)
  if( i == 3 ) break
}

# break can be used to create more complex while loops
set.seed(24601)
while( TRUE ) {
  r<-runif(1)
  print(r)
  if( r > 0.4 & r < 0.45 ) break
  if( r > 0.76 & r < 0.8 ) break
}

# next skips the current iteration of the loop, 
# proceeding to the next interation
for(i in c(1:5) ) {
  if( i == 3 ) next
  print(i)
}

# can be used to skip over elements depending on 
# certain characteristics of the elements
x<-list(c(1,2,3),c("a","b,","c"),c(4,5,6))
for(i in x ) {
  if( class(i) != "numeric" ) next
  print(mean(i))
}

#######################################
# Stop, Warning, and Try
#######################################

# stop will stop executing a function, issuing an error
mysum<-function(x,y) {
  if( class(x) != "numeric" | class(y) != "numeric" ) 
    stop("x and y must be numeric")
  if( length(x) != length(y) ) 
    stop("x and y must be of the same length")
  return(x+y)
}
mysum(1,"a")
mysum(c(1,2,3),c(1,2))
mysum(c(1,2,3),c(4,5,6))


# warning will not stop a function, but will print a warning message
mysum<-function(x,y) {
  if( class(x) != "numeric" | class(y) != "numeric" ) 
    stop("x and y must be numeric")
  if( length(x) != length(y) ) {
    warning("x and y are not the same length. The shorter will be repeated as needed to make them the same length.")
    num<-ifelse(length(x) > length(y), length(x), length(y))
    x<-rep(x,length.out=num)
    y<-rep(y,length.out=num)
  }
  return(x+y)
}
mysum(c(1,2,3),c(4,5))

# try executes a statement and will capture an error if one is thrown
# the program will continue to run even if there is an error
# try returns an object containing information about the error if an error is thrown
# try return the result of the expression if there is no error
library(QCA)
data(d.jobsecurity)
truth<-truthTable(d.jobsecurity,outcome="JSR",
                  conditions=c("S","C","P"),
                  sort.by="incl")
print(truth)
sol<-try(eqmcc(truth,details=TRUE))
if( class(sol) == "try-error" ) {
  print("The truth table couldn't be reduced")
} else {  
  print(sol)
}
