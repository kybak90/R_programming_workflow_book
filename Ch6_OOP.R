# 클래스와 속성
num_vec = 1:5
class(num_vec) = "new_class"
print(num_vec)
class(num_vec)


num_vec2 = structure(1:5, class = "new_class")
print(num_vec2)


df = data.frame(a = 1:4, b = 5:8)
class(df)
attributes(df)
names(df)



# 제너릭 함수
print
methods(print)[1:20]
print.data.frame(df)
print.data.frame


x = 1:5
class(x)
plot(x)


lm_fit = lm(log(mpg) ~ log(disp), data = mtcars)
class(lm_fit)
plot(lm_fit)



# 제너릭 함수와 메서드의 구현
my_function = function(x) UseMethod("my_function")

my_function.default = function(x)
{
  cat("일반 객체입니다:", x, "\n")
}

my_function.person_info = function(x)
{
  cat("이름:", x$name, "나이:", x$age, "\n")
}


p = list(name = "Kwan-Young Bak", age = 35)
class(p) = "person_info"

my_function(42)
my_function(p)




# 스플라인 기저 함수 플랏 메서드
## B-스플라인 기저 함수 값을 계산하는 함수
b_spline = function(x, knots, degree, i) {
  if (degree == 0) {
    return(ifelse(knots[i] <= x & x < knots[i + 1], 1, 0))
  }
  
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


## 데이터를 기반으로 설계 행렬을 생성하는 함수 (basis 클래스 부여)
create_design_matrix = function(x_values, knots, degree) {
  n = length(x_values) # 데이터 포인트 갯수
  num_basis = length(knots) - degree - 1 # 기저 함수 갯수
  design_matrix = matrix(0, nrow = n, ncol = num_basis) # 설계 행렬 초기화
  
  for (j in 1:num_basis)
    for (i in 1:n)
      design_matrix[i, j] = b_spline(x_values[i], knots, degree, j)
  
  attr(design_matrix, "x_values") = x_values # 벡터 x 값 저장
  attr(design_matrix, "knots") = knots # 매듭점 시퀀스 저장
  attr(design_matrix, "degree") = degree # 스플라인 차수 저장
  class(design_matrix) = "basis" # "basis" 클래스 부여
  
  return(design_matrix)
}


## 원래 데이터와 적합된 스플라인 회귀 곡선을 시각화하는 함수 (S3 메서드 이용)
plot.basis = function(basis_obj, ...) {
  x_values = attr(basis_obj, "x_values")
  
  if (is.null(x_values))
    stop("x_values attribute is missing in the basis object.")
  
  matplot(x_values, basis_obj, type = "l", lty = 1,
          col = rainbow(ncol(basis_obj)),
          xlab = "x", ylab = "B-spline value", ...)
}



## 스플라인 회귀 적합을 위한 데이터 생성
degree = 3
tiny = 1e-5
knots = c(rep(0 - tiny, degree), 0, 1, 2, 3, 4, rep(4 + tiny, degree))
x_values = seq(0, 4, length.out = 200)


## basis 오브젝트 생성
basis_obj = create_design_matrix(x_values, knots, degree)
attributes(basis_obj)$knots
class(basis_obj)

## S3 메서드를 이용한 시각화
plot(basis_obj)