#sink will write the output of the source file to a text file
#wihout split, sink will only output stuff to the next file - 
##you won't get output in the console. 
#Usinng split=TRUE means output is "split" between the console 
##and the text file, so you get output in both
sink("test.txt",split=TRUE)

x<-c(1,2,3,4,5)

y<-c(6,7,8,9,10)

z<-x*y

print(z)

sink()