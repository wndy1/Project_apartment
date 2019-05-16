
################지가변동률  EDA #####################################################
setwd("C:\\Users\\user\\Desktop\\Project_apartment\\하나영\\혼인건수")
## csv file load
marr = read.csv('Marriage.csv',header=T,stringsAsFactors=F)

# 기초정보
dim(marr)


#  평균 혼인건수 데이터
marr_mean = marr[,2]

# 평균, 분산
mean(marr_mean);sd(lv_mean)

graphics.off()
# 그래프
windows()
par(mfrow=c(1,2))
hist(lv_mean,breaks = 40)
boxplot(lv_mean)
# 왼쪽으로 쏠려 있는 모습이며, outlier가 있는 것으로 보인다.

# 정규확률그림
windows()
qqnorm(lv_mean)
# 정규확률그림이 아래로 볼록한 형태이므로 데이터의 분포가 왼쪽으로 쏠려있는 형태라는 것을 알 수 있다.

# 기술통계량
summary(lv_mean)
# 평균이 중앙값보다 크므로 왼쪽으로 쏠려 있는 분포라는 것을 알 수 있다.

# 왜도 및 첨도
# 왜도, 첨도
library(moments)
skewness(lv_mean)
kurtosis(lv_mean) # 정규분포와 비슷한 꼬리를 갖는다고 하기 힘들다
# Agostino skewness test
# 왜도가 0인지 검정
agostino.test(lv_mean)
# p-value가 매우 작으므로 유의수준 0.05에서 왜도가 0이라고 하기 힘들다

# 첨도가 3인지 검정
anscombe.test(lv_mean)
# p-value가 작으므로 유의수준 0.05에서 첨도가 3이라고 하기 힘들다

# 정규성 검정
shapiro.test(lv_mean)
# p-value가 매우 작으므로 유의수준 0.05에서 귀무가설 기각(귀무가설 : 정규분포를 따른다)
# 정규분포를 따른다고 하기 힘들다

jarque.test(lv_mean)

library(nortest)

# kolmogorov-smirnov test
lillie.test(lv_mean)
ad.test(lv_mean)


