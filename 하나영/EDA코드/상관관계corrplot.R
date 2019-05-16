setwd("C:\\Users\\user\\Desktop\\Project_apartment")
dat<-read.csv("단지별변수(new).csv", header=T)
str(dat)

##구별로 corr 분석하기
dat$구시군 = as.character(dat$구시군)
loc=dat$구시군

#loc
Ganghwa=grep("강화군",loc)
Geyang<-grep("계양구",loc)
Namdong<-grep("남동구",loc)
Donggu<-grep("동구",loc)
Michuhall<-grep("미추홀구", loc)
Bupyeng<-grep("부평구", loc)
seogu<-grep("서구", loc)
yeons<-grep("연수구", loc)
jungguu<-grep("중구", loc)

#install.packages("corrplot")
library(corrplot)

#강화군 corr
dat1<-dat[c(1:20),c(5:9,11:14,16:18)]
str(dat1)
sum(is.na(dat1))
dat1_cor<-cor(dat1)
#scatter plot matrix
plot(dat1)
#corrplot
windows()
corrplot(dat1_cor,method="circle")


#계양구 
dat2<-dat[c(21:424),c(5:9,11:14,16:18)]
str(dat2)
sum(is.na(dat2))
dat1_cor<-cor(dat2)
plot(dat2)
windows()
corrplot(dat2_cor,method="circle")
graphics.off()

#
Namdong
dat3<-dat[c(Namdong),c(5:9,11:14,16:18)]
str(dat3)
sum(is.na(dat3))
dat3_cor<-cor(dat3)
windows()
par(mfrow=c(2,1))
plot(dat3)
corrplot(dat3_cor,method="circle")
graphics.off()


