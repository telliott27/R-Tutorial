sink(file="week5-hw-console.txt",split=TRUE)
library(foreign)
library(dplyr)

hire<-read.dta("hire771.dta")

#output first 10 rows of the dataset
print(hire[1:10,])

#create factor variable for sex
hire$sex.factor<-factor(hire$sex,levels=c(0,1),labels=c("Female","Male"))

#check factor was created correctly
table(hire$sex,hire$sex.factor)

#rename sex to male
names(hire)[2]<-"male"
#OR
#names<-rename(names,male=sex)

#create factor variable for ethnic
hire$ethnic.factor<-factor(hire$ethnic,levels=c(0,1,2,3,4),
                           labels=c("White","African-American","Asian","Native American","Hispanic"))

#check factor was created correctly
table(hire$ethnic,hire$ethnic.factor)

#Create a dummy variable for black
hire$black<-(hire$ethnic.factor=="African-American")*1

#check coding
table(hire$black)

#Create categorical variable from salary
hire$salary.cat<-cut(hire$salary,breaks=c(-Inf,100,200,Inf),labels=c("Low","Medium","High"))

#Check coding
table(hire$salary.cat)

save(hire,file="hire771.Rdata")

sink(NULL)
