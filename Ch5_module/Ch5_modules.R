# B-스플라인 기저 함수 값을 계산하는 함수
# b_spline(x, knots, degree, i)
# - x:입력 데이터(스칼라 값)
# - knots: B-스플라인 매듭점(벡터)
# - degree: B-스플라인의 차수(정수)
# - i:해당 기저 함수의 인덱스(정수)
# - 반환값:해당x에서의B-스플라인 기저 함수 값(스칼라 값)
b_spline = function(x, knots, degree, i) {
  # 0차 B-스플라인 기저함수의 경우 (구간별 상수 함수)
  if (degree == 0) {
    return(ifelse(knots[i] <= x & x < knots[i + 1], 1, 0))
  }
  # 재귀적인 경우 (차수 d > 0)
  B_i_d1 = b_spline(x, knots, degree - 1, i)
  B_i1_d1 = b_spline(x, knots, degree - 1, i + 1)
  denom1 = knots[i + degree] - knots[i]
  denom2 = knots[i + degree + 1] - knots[i + 1]
  term1 = if (denom1 == 0) 0 else
    ((x - knots[i]) / denom1) * B_i_d1
  term2 = if (denom2 == 0) 0 else
    ((knots[i + degree + 1] - x) / denom2) * B_i1_d1
  return(term1 + term2)
}





# 데이터를 기반으로 설계 행렬을 생성하는 함수
# create_design_matrix(x_values, knots, degree)
# - x_values: 입력 데이터 (벡터)
# - knots: B-스플라인 매듭점 (벡터)
# - degree: B-스플라인의 차수 (정수)
# - 반환값: B-스플라인 기저 함수로 구성된 설계 행렬 (행렬)
create_design_matrix = function(x_values, knots, degree)
{
  n = length(x_values) # 샘플의 갯수
  num_basis = length(knots) - degree - 1 # 기저 함수의 갯수
  design_matrix = matrix(0, nrow = n, ncol = num_basis) # 설계 행렬 초기화
  for (j in 1:num_basis)
    for (i in 1:n)
      design_matrix[i, j] = b_spline(x_values[i], knots, degree, j)
  return(design_matrix)
}





# 최소제곱 추정법을 적용하여 회귀 계수를 계산하는 함수
# fit_spline(x_values, y_values, knots, degree)
# - x_values: 입력 데이터 (벡터)
# - y_values: 목표 값 (벡터)
# - knots: B-스플라인 매듭점 (벡터)
# - degree: B-스플라인의 차수 (정수)
# - 반환값: 회귀 계수 및 모델 정보 (리스트)
fit_spline = function(x_values, y_values, knots, degree)
{
  G = create_design_matrix(x_values, knots, degree)
  beta = solve(t(G) %*% G) %*% t(G) %*% y_values
  return(list(beta = beta, knots = knots, degree = degree))
}





# 새로운 데이터에 대한 예측을 수행하는 함수
# predict_spline(model, new_x)
# - model: fit_spline()으로 학습된 스플라인 모델 (리스트)
# - new_x: 예측을 수행할 x 값 (벡터)
# - 반환값: 예측된 y 값 (벡터)
predict_spline = function(model, new_x)
{
  G_new = create_design_matrix(new_x, model$knots, model$degree)
  y_pred = G_new %*% model$beta
  return(y_pred)
}





# 원래 데이터와 적합된 스플라인 회귀 곡선을 시각화하는 함수
# plot_spline(x_values, y_values, model, grid_x)
# - x_values: 원본 데이터 (벡터)
# - y_values: 원본 데이터의 목표 값 (벡터)
# - model: fit_spline()으로 학습된 스플라인 모델 (리스트)
# - grid_x: 예측할 x 값의 범위 (벡터)
# - 반환값: ggplot을 이용한 스플라인 회귀곡선 시각화 (플롯)
plot_spline = function(x_values, y_values, model, grid_x)
{
  y_pred = predict_spline(model, grid_x)
  data_plot = data.frame(x = x_values, y = y_values)
  spline_plot = data.frame(x = grid_x, y = y_pred)
  ggplot() +
    geom_point(data = data_plot, aes(x, y), color = "black") +
    geom_line(data = spline_plot, aes(x, y), color = "blue", linewidth = 1) +
    labs(title = "Fitted B-spline Regression", x = "x", y = "y") +
    xlim(c(min(x_values), max(x_values))) +
    theme_minimal()
}