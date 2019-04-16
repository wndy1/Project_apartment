rm(list=ls())
setwd("C:\\Users\\user\\Desktop\\DM")
dat<-read.csv("È¥ÀÎµ¥ÀÌÅÍ.csv")
View(dat)

for(i in 2:dim(dat)[2]){
  dat[,i]=as.numeric(as.character(dat[,i]))
}

dat[10,2:25]=dat[4,2:25]

write.csv("Marriage.csv")
