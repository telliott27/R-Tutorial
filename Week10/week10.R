#######################################
# Week 10 Regression
#######################################

library(foreign)
library(dplyr)

# The hire771.dta data set contains weekly starting salaries for people at an unknown firm in 1977.
hire<-read.dta("hire771.dta")

# We will be predicting starting salary using age, gender, race, marital status, and education
# Let's start by cleaning up the data a bit

# create factor variable for categorical variables
hire$marital.fac<-factor(hire$marital,levels=c(0,1,2,3,4),
                         labels=c("Single","Married","Divorced","Widower","Separated"))
#make sure marital factored correctly
table(hire$marital,hire$marital.fac)

hire$educ.fac<-factor(hire$educ,levels=c(0:9),
                      labels=c("< HS","High School","Secretarial School","Some College, <60 credits",
                               "Some College, >60 credits","Associates Degree","Bachelor's Degree",
                               "Some Grad School","Master's Degree","PhD"))
#make sure education factored correctly
table(hire$educ.fac,hire$educ)

hire$ethnic.fac<-factor(hire$ethnic,levels=c(0:4),
                        labels=c("White","African-American","Asian","Native American","Hispanic"))
#make sure ethnic factored correctly
table(hire$ethnic.fac,hire$ethnic)

hire$sex.fac<-factor(hire$sex,levels=c(0,1),labels=c("Male","Female"))
#make sure sex factored correctly
table(hire$sex.fac,hire$sex)

#for simplicity, we will create some dummies:
hire<-mutate(hire,married=(marital.fac=="Married")*1,
             white=(ethnic.fac=="White")*1,
             bachelors=(educ>=6)*1)

#OLS regression is done using the lm() command, for linear model
#the model is defined by a formula object. It looks like y ~ x1 + x2 + x3 ...
sal.lm<-lm(salary ~ age + sex + white + married + bachelors,data=hire)

#to display the results, use the summary() command
summary(sal.lm)


# Now let's see how to do logistic regression
# first, we will create a DV that measures whether someone is except, meaning they are except from overtime pay

hire$wagecode.fac<-factor(hire$wagecode,levels=c(0:3),
                          labels=c("Nonexcept","Administrative","Professional","Executive"))
hire<-mutate(hire,except=(wagecode!=0)*1)
table(hire$wagecode.fac,hire$except)

# logistic regression is accomplished with the glm() function, or generalized linear models
# this function is incredibly powerful, allowing you to run many many different kinds of regressions
# to run logistic regression, we tell glm() to use the binomial family of distributions (which defaults to the logit link function)

except.glm<-glm(except ~ age + sex + white + married + bachelors,family="binomial",data=hire)

#again, to see the results, use the summary() command
summary(except.glm)

# to see the help file for glm:
?glm
# to see the help file for the different families you can use with glm
?family

# NOTE: using glm with the gaussian family will reproduce the results from OLS, 
# though glm uses MLE to calculate the coefficients so you will get model summary
# stats appropriate for MLE rather than OLS

# like Stata, R also has third party packages for formatting regression results
# in a publisher ready way. Unfortunately, these packages are focused on producing results
# for LaTeX documents. However, Stargazer will produce HTML documents which Word can easily read:
library(stargazer) # will need to install the package before using it the first time

# stargazer will take one or more regression objects and return formatted results:
stargazer(sal.lm,except.glm,type="text")

#you can specify a filename in the out argument to save the output to a file
stargazer(sal.lm,except.glm,type="text",out="hire_regress.txt")

#to open in word, want to set the type to "html"
stargazer(sal.lm,except.glm,type="html",out="hire_regress.html")

#stargazer has a LOT of options for modifying the output. It also recognizes many different types of objects
# and will format as appropriate. It can be passed a dataframe and it will automatically produce
# a table for descriptive statistics. To see the many different ways you can use stargazer, see its vignette
vignette("stargazer")
