import os
import sys
import pandas as pd
import numpy as np
from pandas import Series, DataFrame
import xlrd
from xlrd import XLRDError


# 2016년 ~ 2019년 월별 인천 구별 세대수 함수

def Nogu(gu_name):
    # 초기값 설정 2016년 1월
    gu1 = pd.read_excel("./인구및세대현황(군구-동별)201601.xlsx",sheet_name="인천광역시 "+str(gu_name)+" 2016.01",index_col=0)
    gu1=gu1.drop(gu1.index[0:3],axis=0)
    gu1=gu1.drop(gu1.columns[0:7],axis=1)
    gu1=gu1.drop(gu1.columns[1],axis=1)
    gu1.columns.values[0] = "2016.01" 
    gu_res = gu1
    for j in [6,7,8]: # 16년 1월~ 18년 12월까지
        for i in range(1,13): # 16년 ~ 18년 1월부터 12월까지
            try:
                if i < 10: # 1~9월까지
                    gu = pd.read_excel("./인구및세대현황(군구-동별)201"+str(j)+"0"+str(i)+".xlsx",sheet_name="인천광역시 "+str(gu_name)+" 201"+str(j)+".0"+str(i),index_col=0)
                    gu=gu.drop(gu.index[0:3],axis=0) # 필요없는 행 삭제
                    gu=gu.drop(gu.columns[0:7],axis=1) # 필요없는 열 삭제
                    gu=gu.drop(gu.columns[1],axis=1)
                    gu.columns.values[0] = "201"+str(j)+"."+str(i) # 컬럼명 수정 -> 2016.1 이런식
                elif i>=10: # 10월 이상인 경우
                    gu = pd.read_excel("./인구및세대현황(군구-동별)201"+str(j)+str(i)+".xlsx",sheet_name="인천광역시 "+str(gu_name)+" 201"+str(j)+"."+str(i),index_col=0)
                    gu=gu.drop(gu.index[0:3],axis=0)
                    gu=gu.drop(gu.columns[0:7],axis=1) # 필요없는 열 삭제
                    gu=gu.drop(gu.columns[1],axis=1)
                    gu.columns.values[0] = "201"+str(j)+"."+str(i)
                gu_res = pd.concat([gu_res,gu],axis=1) # 열 결합
            except xlrd.XLRDError: # 17년 7~9월 데이터 누락으로 인한 오류 방지
                gu_res["201"+str(j)+"."+str(i)] = 0
    gu_res = gu_res.drop(gu_res.columns[0],axis=1)
    # gu_res = gu_res.drop(gu_res.index["행정기관"],axis=0)
    return gu_res.to_csv("./인천광역시 "+str(gu_name)+" 세대수.csv",encoding='ms949')

# 남구와 미추홀구 전용 함수
def Nogu2(gu_name):
    # 초기값 설정 2016년 1월
    gu1 = pd.read_excel("./인구및세대현황(군구-동별)201601.xlsx",sheet_name="인천광역시 "+str(gu_name)+" 2016.01",index_col=0)
    gu1=gu1.drop(gu1.index[0:3],axis=0)
    gu1=gu1.drop(gu1.columns[0:7],axis=1)
    gu1=gu1.drop(gu1.columns[1],axis=1)
    gu1.columns.values[0] = "2016.01"
    gu_res = gu1
    for j in [6,7,8]: # 16년 1월~ 18년 12월까지
        for i in range(1,13): # 16년 ~ 18년 1월부터 12월까지
            try:
                if i < 10: # 1~9월까지
                    gu = pd.read_excel("./인구및세대현황(군구-동별)201"+str(j)+"0"+str(i)+".xlsx",sheet_name=2,index_col=0) # 2017.07 파일에 세번째 시트가 없기 때문에 IndexError 오류가 발생
                    gu=gu.drop(gu.index[0:3],axis=0) # 필요없는 행 삭제
                    gu=gu.drop(gu.columns[0:7],axis=1) # 필요없는 열 삭제
                    gu=gu.drop(gu.columns[1],axis=1)
                    gu.columns.values[0] = "201"+str(j)+"."+str(i) # 컬럼명 수정 -> 2016.1 이런식
                elif i>=10: # 10월 이상인 경우
                    gu = pd.read_excel("./인구및세대현황(군구-동별)201"+str(j)+str(i)+".xlsx",sheet_name=2,index_col=0)
                    gu=gu.drop(gu.index[0:3],axis=0)
                    gu=gu.drop(gu.columns[0:7],axis=1) # 필요없는 열 삭제
                    gu=gu.drop(gu.columns[1],axis=1)
                    gu.columns.values[0] = "201"+str(j)+"."+str(i)
                gu_res = pd.concat([gu_res,gu],axis=1) # 열 결합
            except (xlrd.XLRDError, IndexError): # 17년 7~9월 데이터 누락으로 인한 오류 방지, 여러개의 오류 입력시 튜플형태로 입력
                # xlrd.XLRDError : 엑셀관련 오류
                # IndexError : 리스트보다 넓은 범위 인덱스 시 발생하는 오류
                gu_res["201"+str(j)+"."+str(i)] = 0
    gu_res = gu_res.drop(gu_res.columns[0],axis=1)
    # gu_res = gu_res.drop(gu_res.index["행정기관"],axis=0)
    return gu_res.to_csv("./인천광역시 미추홀구 세대수.csv",encoding='ms949')
    
    
