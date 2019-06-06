### 인천광역시 지가변동률  EDA ###
## 시계열 자료
rm(list=ls())
## set working directory
setwd('C:\\Users\\user\\Desktop\\Project_DEMA\\Project_apartment\\하나영\\지가변동률')

## Load csv file
dat = read.csv('지가변동률데이터.csv',header=T,stringsAsFactors=F)
#View(dat)

## 기초정보
dim(dat)
## 각 구별 월별로 인구 수 변화
# 구군 이름
gu_name = unique(dat$시군구)
gu_name
## 각 구별 합계 행 위치 찾기
gu_sumrow = c()
for (i in 1:length(gu_name)){
  gu_sumrow[i] = which(dat$시군구==gu_name[i] & dat$행정구역=="합계")
}
gu_sumrow

## 구군별 합계 시계열 데이터 매트릭스
# data에 transpose 하는 이유는 plot 에서 행 벡터 인식 X 열 벡터 인식 O
gu_dat = t(dat[gu_sumrow,3:38])
incheon_sum = apply(gu_dat, 1,sum)
gu_dat = cbind(gu_dat,incheon_sum)
ts_gu_mat = ts(data = gu_dat,start = c(2016),frequency = 36)
min(ts_gu_mat);max(ts_gu_mat[,1:10])
## 구군별 시계열 그래프 하나의 창으로 모아보기
windows()
par(mfrow=c(2,5))
for(i in 1:length(gu_name)){
  dates = seq(as.Date("2016-01-01"), by = "month", along = ts_gu_mat[,i]) # 날짜 201601~201812 생    
  tsp = attributes(ts_gu_mat[,i])$tsp
  plot(ts_gu_mat[,i],xaxt = "n",main = paste(gu_name[i],' 지가변동률 ',sep=''),
       ylab = paste(gu_name[i],' 지가변동 ',sep=''),xlab = '201601 ~ 201812')
  axis(1, at = seq(tsp[1], tsp[2], along = ts_gu_mat[,i]), labels = format(dates,"%Y%m"))
}
## 구군별 시계열 그래프 개별로 보기
for(i in 1:length(gu_name)){
  dates = seq(as.Date("2016-01-01"), by = "month", along = ts_gu_mat[,i]) # 날짜 201601~201812 생    
  tsp = attributes(ts_gu_mat[,i])$tsp
  windows()
  plot(ts_gu_mat[,i],xaxt = "n",main = paste(gu_name[i],' 인구수 변화',sep=''),
       ylab = paste(gu_name[i],' 인구수',sep=''),xlab = '201601 ~ 201812')
  axis(1, at = seq(tsp[1], tsp[2], along = ts_gu_mat[,i]), labels = format(dates,"%Y%m"))
}
## 인천광역시 전체 지가변동률 그래프
dates = seq(as.Date("2016-01-01"), by = "month", along = ts_gu_mat[,11]) # 날짜 201601~201812 생    
tsp = attributes(ts_gu_mat[,11])$tsp
windows()
plot(ts_gu_mat[,11],xaxt = "n",main = paste('인천광역시',' 전체 지가변동률',sep=''),
     ylab = paste('인천광역시',' 지가변동 ',sep=''),xlab = '201601 ~ 201812')
axis(1, at = seq(tsp[1], tsp[2], along = ts_gu_mat[,11]), labels = format(dates,"%Y%m"))
graphics.off()

## 인천광역시 동별 시계열 그래프
## 구군별로 읍면동 시계열 데이터 매트릭스 생성하는 함수
dong_list = function(Gu_name){
  dong_row = which(dat$시군구==Gu_name)
  dong_dat = t(dat[dong_row,3:38])
  ts_dong_mat = ts(data = dong_dat,start = c(2016),frequency = 36)
  return(ts_dong_mat)
}

gu_name
for (i in 1:length(gu_name)){
  a = dong_list(gu_name[i])
  dong_name = dat[dat$시군구==gu_name[i],2]
  windows()
  par(mfrow=c(3,ceiling(ncol(a)/3)))  # 그래프 구역 갯수 설정을 위한 숫자
  for(j in 1:ncol(a)){
    dates = seq(as.Date("2016-01-01"), by = "month", along = a[,j]) # 날짜 201601~201812 생    
    tsp = attributes(a[,j])$tsp
    plot(a[,j],xaxt = "n",main = paste(gu_name[i],' ',dong_name[j],' 지가변동률 ',sep=''),
         ylab = paste(gu_name[i],' ',dong_name[j],' 지가변동ㄹ',sep=''),xlab = '201601 ~ 201812')
    axis(1, at = seq(tsp[1], tsp[2], along = a[,j]), labels = format(dates,"%Y%m"))
  } 
}
graphics.off()
