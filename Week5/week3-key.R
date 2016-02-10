sink(file="week3-key.txt",split=TRUE)
library(forecast)

data<-read.csv("timeseries.csv")

data.ts<-ts(data)

print(data.ts[,"gdp"])
sink(NULL)