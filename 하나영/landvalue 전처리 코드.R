setwd("C:\\Users\\user\\Desktop\\DM")
dat<- read.csv("Áö°¡º¯µ¿·ü(2016.1~2018.12).csv")
head(dat)
#install.packages("dplyr")
library(dplyr)

rownames(dat)<- NULL
dat<-dat[-c(5:7,9:11,13:14,16:21,23:24,30:31,42:43,46:47),]  
View(dat)
write.csv(dat,"landvalue.csv")

