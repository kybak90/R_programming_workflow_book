library(reticulate)

#use_python("path") : 원하는 Python 경로 지정
#use_virtualenv("myenv") : Python 가상 환경을 사용
#use_condaenv("myenv") :  Conda 가상 환경을 사용

# r-reticulate 환경이 자동으로 생성되지 않을 수 있으므로 명시적으로 생성
# reticulate 1.41부터는 py_require()를 통한 자동 환경 관리도 지원

# 방법 1: 환경 생성 함수를 직접 호출
virtualenv_create("r-reticulate")

# 방법 2: 환경이 존재하지 않을 때만 생성
if (!virtualenv_exists("r-reticulate")) {
  virtualenv_create("r-reticulate")
}

use_virtualenv("r-reticulate")
py_install("numpy")
np = import("numpy")
np$arange(10)


# R과 Python을 연동하는 머신러닝 예제
## 데이터 불러오기
data("mtcars")
head(mtcars, 10)



## lm() 함수로 선형 회귀 적합
lm(mpg ~ ., data = mtcars)$coefficients



##  Python의 sklearn.linear_model 모듈을 불러와서 R에서 적합
### 모듈 불러오기
# py_install("scikit-learn")
skl_lr = import("sklearn.linear_model")

### 설명 변수와 반응 변수 설정
x = as.matrix(mtcars[, -1])
y = as.numeric(mtcars[, 1])

### 파이썬 객체(numpy 배열)로 변환
np = import("numpy")
pyx = np$array(x)
pyy = np$array(y)

### 선형 회귀 모델 생성
lr = skl_lr$LinearRegression()
lr$fit(pyx, pyy)

### 계수와 절편 저장 및 출력
coefficients = lr$coef_
intercept = lr$intercept_
coefficients
cat("Intercept: ", intercept, "\n")


## py_run_string() 함수를 사용해 python 코드 직접 실행
### 설명 변수와 반응 변수 설정
x = as.matrix(mtcars[, -1])
y = as.numeric(mtcars[, 1])

### 파이썬 객체(numpy 배열)로 변환
np = import("numpy")
pyx = np$array(x)
pyy = np$array(y)

### 파이썬 코드 문자열 생성
python_code = "
from sklearn.linear_model import LinearRegression

# 데이터 준비
X = r.pyx
y = r.pyy

# 모델 생성 및 학습
lr = LinearRegression()
lr.fit(X, y)

# 계수와 절편 추출
coefficients = lr.coef_
intercept = lr.intercept_

# 결과 출력
print('Coefficients:', coefficients)
print('Intercept:', intercept)
"

### 파이썬 코드 실행
py_run_string(python_code)
