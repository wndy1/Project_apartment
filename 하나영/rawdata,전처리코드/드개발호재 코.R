rm(list=ls())
getwd()
setwd("C:\\Users\\user\\Desktop\\Project_apartment\\정동호")
#dir() 파일명 
dat = read.csv("단지별변수(수정).csv")

#View(dat)
#str(dat)
dat$읍면동 = as.character(dat$읍면동)
loc = dat$읍면동 
#loc
dangha = grep('당하동', loc)
wondang = grep('원당동', loc)
bulo = grep('불로대곡동' , loc)
songdo=grep('송도동', loc)

eunseo=grep('운서동', loc)
youngjong=grep('영종동',loc)
dohwa=grep('도화동',loc)
soongee=grep('숭의동',loc)
chungla=grep('청라동', loc)
suknam=grep('석남동',loc)
gaza=grep('가좌동',loc)
gajung=grep('가정동',loc)
gumdan=grep('검단동',loc)
bupyeong=grep('부평동',loc)
hwasu = grep('화수동', loc) 
songlim=grep('송림동',loc)

#dep=c("dangha","wondang","bulo","songdo","eunseo",
#   "youngjong","dohwa","soongee","chungla",
# "suknam", "gaza","gajung","gumdan","bupyeong","hwasu","songlim")

#dat[dep, ]$개발호재유무 = "1"

#View(dat)


dat[dangha,]$개발호재유무 =  1 
dat[wondang,]$개발호재유무 = 1
dat[bulo,]$개발호재유무 = 1
dat[songdo,]$개발호재유무 = 1
dat[hwasu,]$개발호재유무 = 1
dat[songlim,]$개발호재유무 = 1
dat[eunseo,]$개발호재유무 = 1
dat[youngjong,]$개발호재유무 = 1
dat[dohwa,]$개발호재유무 = 1
dat[soongee,]$개발호재유무 = 1
dat[chungla,]$개발호재유무 =1
dat[suknam,]$개발호재유무 = 1
dat[gaza,]$개발호재유무 = 1
dat[gajung,]$개발호재유무 =1
dat[gumdan,]$개발호재유무 =1
dat[bupyeong,]$개발호재유무 = 1
dat[hwasu,]$개발호재유무 = 1
dat[songlim,]$개발호재유무 = 1
?which
dat[which(is.na(dat$개발호재유무)),]$개발호재유무<-0

View(dat)
write.csv(dat,'단지별변수(추가).csv')

