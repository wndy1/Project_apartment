### Regression Model ###
# library
#install.packages("moments")
#install.packages("nortest")
#install.packages("car")
#install.packages("corrplot")
library(moments)
library(nortest)
library(car)
library(corrplot)
# set directory
setwd("C:\\Users\\user\\Desktop\\Project_DEMA\\Project_apartment")

## load train set, validation set, test set
train = read.csv('train set.csv',header = T,stringsAsFactors = F)
valid = read.csv('validation set.csv',header = T,stringsAsFactors = F)
test = read.csv('test set.csv',header = T,stringsAsFactors = F)
# 불필요한 열 제거
train = train[,-c(1,2,3)]
valid = valid[,-c(1,2,3)]
test = test[,-c(1,2,3)]
##
colnames(train)
colnames(valid)
colnames(test)

# categorical variable
table(train$개발호재)

## Multiple regression model
# Model : Y = B0 + B1X1 + B2X2 + ... + BpXp + E

# 변수 설정
Y = train$평균매매가
X1 = train$분양면적
X2 = train$단지세대수
X3 = train$개별세대수
X4 = train$노후도
X5 = train$역세권점수
X6 = train$평균전세가
X7 = train$토지면적
X8 = train$문화시설수
X9 = train$쇼핑시설수
X10 = train$스타벅스
X11 = train$평균인구수
X12 = train$평균세대수
X13 = train$교육시설수
X14 = train$개발호재
X15 = train$평균혼인건수
# 회귀 적합
reg.train = lm(Y~X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X11+X12+X13+factor(X14)+X15,data=train)


# validation set으로 모델 평가
coef = reg.train$coefficients
valid.mat = valid
valid.mat[,1] = 1
valid.mat = as.matrix(valid.mat)
View(valid.mat)
# predict valid.hat
valid.hat = as.vector(coef%*%t(valid.mat))

e = valid$평균매매가 - valid.hat
n = nrow(valid)
p = 15

x11()
plot(valid.hat~valid$평균매매가)

# MSE 구하기
sum(e^2)/(n-p-1) # 1220.949
# adjusted R2 구하기
SSE.valid = sum(e^2)
SST.valid = sum((valid$평균매매가-mean(valid$평균매매가))^2)
SSE.valid
SST.valid

ad.R2.valid = 1-((SSE.valid/(n-p-1))/(SST.valid/(n-1)))
ad.R2.valid # 0.7881567

## 모형 진단하기
summary(reg.train)
x11()
par(mfrow=c(2,2))
plot(reg.train)


x11()
plot(fitted(reg.train)~train$평균매매가)

# outlier 판단
x11()
plot(cooks.distance(reg.train))
# outlier가 있다고 판단되자만

# 독립성 검정
durbinWatsonTest(reg.train)
# 더빈 왓슨 통계량이 2보다 크므로, 자기상관성이 없다고 볼 수 있다.

# 선형성
res.train = resid(reg.train)
x11()
plot(res.train ~ fitted(reg.train))

# 등분산성
x11()
plot(rstandard(reg.train))

x11()
plot(rstudent(reg.train))

## 정규성 검정
# histogram
x11()
hist(res.train)
# skewness & kurtosis
skewness(res.train)
agostino.test(res.train) # p-value가 유의수준 0.05보다 작으므로 skewness는 0이 아니라 할 수 있다.
kurtosis(res.train)
anscombe.test(res.train) # p-vlaue가 유의수준 0.05보다 작으므로 kurtosis는 3이 아니라 할 수 있다.

shapiro.test(res.train)
lillie.test(res.train)
ad.test(res.train)


x11()
qqnorm(res.train)
qqline(res.train,col=2)
# 잔차의 정규성에 대한 검정은 맞지 않다고 하지만, 중심극한정리에 따라 샘플의 수가 많기 때문에 상관없다?

## 다중공선성
x11()
corrplot.mixed(cor(train[,2:15]))
 x11()
 pairs(Y~X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X11+X12+X13+X14+X15,data = train)
vif(reg.train)>10
# vif > 10 다중공선성이 존재한다고 볼 수 있다.
# X11과 X12이 다중공선성이 존재한다고 볼 수 있다.
# X11 : 평균인구수
# X12 : 평균세대수 
# 평균인구수와 평균세대수의 상관관계 분석
cor(X11,X12)
cor(Y,X11)
cor(Y,X12)
x11()
plot(X11,X12)

summary(reg.train)

#이상치
car::outlierTest(reg.train)
#영향관측치 
x11()
cutoff <- 4/(nrow(train)-length(reg.train$coefficients)-2)
plot(reg.train, which=4, cook.levels=cutoff)
abline(h=cutoff, lty=2, col="red")

#train2<-train[-c(548,1094),] #영종동,논현ㄷ동(웰카운티)

### VIF 존재에 따른 모델 선택
## 원래 모델에 variable selection 
## X11 제거 후 or X12 제거 후 비교해서 회귀모형 진단후 variable selection

## 1. 원래 모델에 variable selection
reg.train1 = lm(Y~1,data=train)
# stepwise selection
reg.train.stepwise1 =step(reg.train1, scope = list(upper = reg.train,lower = reg.train1),direction = 'both')
# Y ~ X6 + X4 + X13 + factor(X14) + X5 + X9 + X11 + X12 + X2 + X15 + X7 + x8
# 빠진 변수 : X1, X3, X10
# lm(Y ~ X2+X4+X5+X6+X7+X8+X9+X11+X12+X13+factor(X14)+X15,data=train)

coef.stepwise1 = reg.train.stepwise1$coefficients
summary(reg.train.stepwise1)
#변수선택 1. forward selection

for11<-step(reg.train1, scope = list(upper = reg.train,lower = reg.train1),direction = 'forward')
summary(for11)
#결정계수(R^2)가 0.7967

#2.backward
back11<-step(reg.train, scope = list(upper = reg.train,lower = reg.train1),direction = 'backward')
summary(back11)
#결정게수 0.7968




# predict valid.hat
valid.mat1 = valid[,-c(2,4,11)]
valid.mat1[,1] = 1
valid.mat1 = as.matrix(valid.mat1)

valid.hat1 = as.vector(coef.stepwise1%*%t(valid.mat1))

e1 = valid$평균매매가 - valid.hat1
n = nrow(valid)
p1 = 12

x11()
plot(valid.hat1~valid$평균매매가)

# MSE 구하기
sum(e1^2)/(n-p1-1)
# 기존 1220.949에서 1217.055로 감소
# adjusted R2 구하기
SSE.valid1 = sum(e1^2)
SST.valid1 = sum((valid$평균매매가-mean(valid$평균매매가))^2)
SSE.valid1
SST.valid1

ad.R2.valid1 = 1-((SSE.valid1/(n-p1-1))/(SST.valid1/(n-1)))
ad.R2.valid1 # 0.7888323으로 기존보다 증가

sqrt(vif(reg.train.stepwise1))>sqrt(10)
# X11과 X12 공선성 존재

## 2. X11 제거 후 variable selection 진행
reg.train2 = lm(Y~X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X12+X13+factor(X14)+X15,data=train)
summary(reg.train2)
vif(reg.train2)>10
# validation set 을 통한 검증
coef2 = reg.train2$coefficients
valid.mat2 = valid[,-12]
valid.mat2[,1] = 1
valid.mat2 = as.matrix(valid.mat2)
View(valid.mat)
# predict valid.hat
valid.hat2 = as.vector(coef2%*%t(valid.mat2))

e2 = valid$평균매매가 - valid.hat2
n = nrow(valid)
p2 = 14

# MSE
sum(e2^2)/(n-p2-1)
# 1347.754로 1220.949보다 높다

# 잔차 분석
x11()
par(mfrow=c(2,2))
plot(reg.train2)

x11()
plot(resid(reg.train2))

x11()
plot(resid(reg.train2)~fitted(reg.train2))

durbinWatsonTest(reg.train2)

# variable selection 진행
reg.train1 = lm(Y~1,data=train)
# stepwise selection
step(reg.train1, scope = list(upper = reg.train2,lower = reg.train1),direction = 'both')
# Y ~ X6 + X4 + X13 + X10 + factor(X14) + X5 + X9 + X7 + x1 + X15 + X2 + X3
# 빠진 변수 : X8, X12
reg.train.stepwise2 = lm(Y ~ X1+X2+X3+X4+X5+X6+X7+X9+X10+X13+factor(X14)+X15,data=train)
coef.stepwise2 = reg.train.stepwise2$coefficients
summary(reg.train.stepwise2)
vif(reg.train.stepwise2)>10
# forward
step(reg.train1, scope = list(upper = reg.train2,lower = reg.train1),direction = 'forward')



# mse 비교
valid.mat2_2 = valid[,-c(9,12,13)]
valid.mat2_2[,1] = 1
valid.mat2_2 = as.matrix(valid.mat2_2)
# predict valid.hat
valid.hat2_2 = as.vector(coef.stepwise2%*%t(valid.mat2_2))

e2_2 = valid$평균매매가 - valid.hat2_2
n = nrow(valid)
p2_2 = 12

# MSE
sum(e2_2^2)/(n-p2_2-1)
# 1348.721

## 3. X12 제거 후 variable selection 진행
reg.train3 = lm(Y~X1+X2+X3+X4+X5+X6+X7+X8+X9+X10+X11+X13+factor(X14)+X15,data=train)
summary(reg.train3)
vif(reg.train3)>10
# validation set 을 통한 검증
coef3 = reg.train3$coefficients
valid.mat3 = valid[,-13]
valid.mat3[,1] = 1
valid.mat3 = as.matrix(valid.mat3)
# predict valid.hat
valid.hat3 = as.vector(coef3%*%t(valid.mat3))

e3 = valid$평균매매가 - valid.hat3
n = nrow(valid)
p3 = 14

# MSE
sum(e3^2)/(n-p3-1)
# 1328.958로 X11 제거시(1347.754)보다 낮고, origin(1220.949)보다는 높다

# 잔차 분석
x11()
plot(reg.train3)

x11()
plot(resid(reg.train3))

x11()
plot(resid(reg.train3)~fitted(reg.train3))

durbinWatsonTest(reg.train3)

# variable selection 진행
reg.train1 = lm(Y~1,data=train)
# stepwise selection
step(reg.train1, scope = list(upper = reg.train3,lower = reg.train1),direction = 'both')
# Y ~ X6 + X4 + X13 + X10 + factor(X14) + X5 + X9 + X11 + x7 + X15 + X1 + X2
# 빠진 변수 : X3, X8
reg.train.stepwise3 = lm(Y ~ X1+X2+X4+X5+X6+X7+X9+X10+X11+X13+factor(X14)+X15,data=train)
coef.stepwise3 = reg.train.stepwise3$coefficients
summary(reg.train.stepwise3)
vif(reg.train.stepwise3)>10

# mse 비교
valid.mat3_1 = valid[,-c(4,9,13)]
valid.mat3_1[,1] = 1
valid.mat3_1 = as.matrix(valid.mat3_1)
# predict valid.hat
valid.hat3_1 = as.vector(coef.stepwise3%*%t(valid.mat3_1))

e3_1 = valid$평균매매가 - valid.hat3_1
n = nrow(valid)
p3_1 = 12

# MSE
sum(e3_1^2)/(n-p3_1-1)
# 1348.721
# 1334.331로 X11제거후 variable selection(1348.721)보다 낮지만, orign varable selection(1217.055)보다는 높다

# stepwise, X12(평균 세대수)를 뺀 회귀모형 적용
