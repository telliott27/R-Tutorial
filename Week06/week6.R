sink(file="week6-R.log",split=TRUE)
#######################################
# Week 6 Regular Expressions
#######################################

# All the built in regular expression functions are documented
# in the same help file

?grep

# regular expressions are used to search and match characters
names<-c("Buffy","Willow","Xander","Cordelia","Giles","Angel","Spike","Anya","Faith")

# grep() will return the indices that match a regular expression
grep("^A",names)

grep("[xyzXYZ]",names)

grep("J",names)

# grepl() will return a logical vector of the same length
grepl("^A",names)

grepl("[aeiou]$",names)

# sub() will return a character vector with the first match in each element replaced
sub("[aeiou]","@",names)

# gsub() will return a character vector with all matches in each element replaced
gsub("[aeiou]","@",names)

sink(NULL)