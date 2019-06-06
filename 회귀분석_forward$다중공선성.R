setwd("C:\\Users\\user\\Desktop\\Project_DEMA\\Project_apartment")

train<-read.csv("train set.csv", header=T)
      test<-read.csv("test set.csv",header=T)
      
      #개발호재유무 범주형 factor 처리
      train$개발호재유무<-as.factor(train$개발호재유무)
      
      head(train)
      
      #불필요한 열 삭제 
      train<-train[,-c(1,2,3)]
      dim(train)
      
      #데이터의 결측값 갯수 총합 확인해보기 
      sum(is.na(train))
      #회귀분석 
      #y<- train$평균매매가.제곱미터당.만원...
      fit<-lm(평균매매가~ ., data=train )
      summary(fit)
      
      ##유의하지 않은 변수가 많아보임. 
      
      #변수선택 1. forward selection
      
      fit.con<- lm(평균매매가~1, data = train)
      fit.forward<- step(fit.con, scope=list(lower=fit.con, upper=fit), direction = "forward")
      summary(fit.forward)
      #결정계수(R^2)가 0.7967
      
      #2.backward
      fit.backward<- step(fit, scope = list(lower = fit.con, upper=fit),direction="backward")
      summary(fit.backward)
      #결정게수 0.7968
      
      #3.stepwise
      fit.both<-step(fit.con, scope=list(lower=fit.con, upper=fit), direction="both")
      summary(fit.both)
      ##결정계수 0.7968
      
      #다중공선성 의심
      #install.packages("car")
      library(car)
      #install.packages("psych")
      library(psych)
      
      #pairs.panels(train[names(train)])
      
      #다중공선성이 있는 변수 찾기 
      vif(fit)>10
      #평균 인구수와 평균 세대수가 다중공선성을 보이고 있다. 
      
      #평균 인구수를 제거
      fit1<-lm( 평균매매가 ~ 평균전세가 + 노후도 + 초중고현황 + 개발호재유무 + 역세권점수 + 쇼핑시설수 + 단지세대수 +X3년.평균.세대수+ 혼인건수3년평균 + 토지면적 + 
      문화시설수, data = train)
      vif(fit1) #평균 세대수>쇼핑시설수 
      summary(fit1) #R^2=0.7674,평균세대수 가장 유의하지 않음 
      
      #평균 세대수를 제거 
      fit2<-lm( 평균매매가 ~ 평균전세가 + 노후도 + 초중고현황 + 개발호재유무 + 역세권점수 + 쇼핑시설수 + 단지세대수 + 혼인건수3년평균 + 토지면적 + 
      문화시설수, data = train)
      vif(fit2) #쇼핑시설수 다중공선성 띔 
      summary(fit2) #결정계수 0.7676, 문화시설수 유의하지 않음 
      
      #1)fit2에서 쇼핑시설수 제거 
      fit3<-lm( 평균매매가 ~ 평균전세가 + 노후도 + 초중고현황 + 개발호재유무 + 역세권점수  + 단지세대수 + 혼인건수3년평균 + 토지면적 + 
      문화시설수, data = train)
      summary(fit3) #결정계수 0.7641
      #2)fit2에서 문화시설수 제거 
      fit4<-lm( 평균매매가 ~ 평균전세가 + 노후도 + 초중고현황 + 개발호재유무 + 역세권점수 + 쇼핑시설수 + 
      단지세대수 + 혼인건수3년평균 + 토지면적 , data = train)
      summary(fit4) #결정계수 0.7675 모든변수 유의 <채택>
      
      
      par(mfrow=c(2,2))
      plot(fit4)
 
