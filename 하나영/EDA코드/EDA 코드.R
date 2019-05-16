setwd("C:\\Users\\user\\Desktop\\Project_apartment\\하나영")
dat2<-read.csv("기준금리.csv",header=F)
hist(dat2$V3,xlab="기준금리")
x<-dat2$V1
y<-dat2$V3
plot(x,y,xlim=c(1999,2018),xlab="년도",ylab="기준금리")


#####################333333333333333333333333333333333
dat<-read.csv("단지별변수().csv",header=T)
head(dat)
Pop<-dat$X3년.평균.인구수
MA<-dat$혼인건수3년평균

plot(MA,Pop)
plot(MA)


Dep<-dat$개발호재유무
y<-dat$매매평균..당가.만원.
plot(Dep,y)

plot(x=dat$지가변동률.누계,y=dat$매매평균..당가.만원.)

(boxstats<-boxplot(dat$토지면적.km2.))
plot(x=dat$토지면적.km2.,y=dat$매매평균..당가.만원.)
plot(x=dat$개발호재유무,y=dat$매매평균..당가.만원.)
dep<-table(dat$혼인건수3년평균)
barplot(dep,main="Marriage",xlab="Number of Marriage")
qqnorm(dat$혼인건수3년평균)
qqnorm(dat$지가변동률.누계)

