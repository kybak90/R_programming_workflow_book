source("Ch5_modules.R")

# B-스플라인 기저 함수 시각화
## 3차 B-스플라인
degree = 3

## 예시 매듭점 (경계 반복 포함)
tiny = 1e-5
knots = c(rep(0 - tiny, degree), 0, 1, 2, 3, 4, rep(4 + tiny, degree))

## 입력 변수 x 생성
x_values = seq(0, 4, length.out = 200)

## 설계 행렬 생성
design_matrix = create_design_matrix(x_values, knots, degree)

## B-스플라인 기저 함수 시각화
matplot(x_values, design_matrix, type = "l", lty = 1,
        col = rainbow(ncol(design_matrix)),
        xlab = "x", ylab = "B-spline value",
        main = "Cubic B-splines")





# 스플라인 함수 시각화 예제
library(ggplot2)
set.seed(1)

## 임의의 계수 (-2에서 2 사이)
coefficients = runif(ncol(design_matrix), -2, 2)

## 스플라인 함수 계산 (기저 함수와 계수의 선형 결합)
spline_values = design_matrix %*% coefficients

## 데이터 프레임으로 변환
spline_data = data.frame(x = x_values, y = spline_values)

## 3차 B-스플라인 함수 시각화
ggplot(spline_data, aes(x = x, y = y)) +
  geom_line(color = "blue", linewidth = 1.2) +
  labs(title = "Cubic B-spline Function",
       x = "x", y = "Spline Value") +
  theme_bw()





#  스플라인 회귀 적합 예제
set.seed(123)
n = 30
x_values = sort(runif(n, 0, 1))
y_values = sin(2 * pi * x_values) + cos(4 * pi * x_values) + rnorm(n, sd = 0.2)

degree = 3
num_knots = 5
tiny = 1e-5
knots = c(rep(0 - tiny, degree), seq(0, 1, length.out = num_knots), rep(1 + tiny, degree))

model = fit_spline(x_values, y_values, knots, degree)
grid_x = seq(min(x_values), max(x_values), length.out = 100)
plot_spline(x_values, y_values, model, grid_x)
