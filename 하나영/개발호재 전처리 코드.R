rm(list=ls())
getwd()
setwd("C:\\Users\\user\\Desktop\\데마 플젝 데이터")
dir()
dat = read.csv("아파트(매매)__실거래가_20190401193845.csv")
View(dat)
str(dat)
dat$시군구 = as.character(dat$시군구)
loc = dat$시군구
majeon = grep('마전동',loc)
danha = grep('당하동', loc)
wondang = grep('원당동', loc)
bulo = grep('불로동', loc)
songdo=grep('송도동', loc)
hwasu = grep('화수동', loc)
songlim=grep('송림동',loc)

dat[majeon,]$개발호재.유무 = "유"
dat[danha,]$개발호재.유무 = "유"
dat[wondang,]$개발호재.유무 = "유"
dat[bulo,]$개발호재.유무 = "유"
dat[songdo,]$개발호재.유무 = "유"
dat[hwasu,]$개발호재.유무 = "유"
dat[songlim,]$개발호재.유무 = "유"

View(dat)
write.csv(dat,'0409전처리.csv')

