library(Rcpp)

# cppFunction()을 사용하여 C++ 코드 실행
cppFunction('
int add(int x, int y)
{
return x + y;
}')
add(2, 3)


# sourceCpp() 함수를 이용하여 .cpp 파일 실행
sourceCpp("my_code.cpp") ## 필요한 경우 .cpp 파일 경로 설정
multiply(3, 4)


# Rcpp 코드 디버깅
add(3, 4)


# 유클리드 거리 함수 예제
## R 코드 
euclidean_distance_r = function(mat)
{
  n = nrow(mat)
  dist_mat = matrix(0, n, n)
  
  for (i in 1:n)
    for (j in 1:n)
      dist_mat[i, j] = sqrt(sum((mat[i, ] - mat[j, ])^2))
  
  return(dist_mat)
}


## cpp 코드
cppFunction('
NumericMatrix euclidean_distance_cpp(NumericMatrix mat) {
int n = mat.nrow();
int d = mat.ncol();
NumericMatrix dist_mat(n, n);
for (int i = 0; i < n; i++) {
for (int j = 0; j < n; j++) {
double sum_sq = 0.0;
for (int k = 0; k < d; k++) {
sum_sq += pow(mat(i, k) - mat(j, k), 2);
}
dist_mat(i, j) = sqrt(sum_sq);
}
}
return dist_mat;
}
')

## 데이터 생성
set.seed(923)
mat = matrix(runif(300 * 10), nrow = 300, ncol = 10)


## 두 함수 비교
dist_mat1 = euclidean_distance_r(mat)
dist_mat2 = euclidean_distance_cpp(mat)

dist_mat1[1:5, 1:5]
dist_mat2[1:5, 1:5]





## microbenchmark()를 이용한 성능 평가 (계산 시간 비교) 
library(microbenchmark)
benchmark_results = microbenchmark(
  R = euclidean_distance_r(mat),
  Rcpp = euclidean_distance_cpp(mat),
  times = 100
)
print(benchmark_results)















