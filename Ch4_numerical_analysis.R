# 정렬 알고리즘 1
selection_sort = function(vec)
{
  ## 길이가 n인 입력 벡터
  n = length(vec)
  
  for (i in 1:(n-1))
  {
    min_index = i
    for (j in (i+1):n)
    {
      if (vec[j] < vec[min_index])
      {
        min_index = j
      }
    }
    if (min_index != i)
    {
      temp = vec[i]
      vec[i] = vec[min_index]
      vec[min_index] = temp
    }
  }
  return(vec)
}

vec = c(6, 9, 2, 12, 7, 4)
sorted_vec = selection_sort(vec)
print(sorted_vec)


set.seed(123)
vec = runif(10)
print(vec)
print(selection_sort(vec))



vec = 3
sorted_vec = selection_sort(vec) ## 에러 발생



# 정렬 알고리즘 2
selection_sort = function(vec)
{
  ## 길이가 n인 입력 벡터
  n = length(vec)
  
  # 입력 벡터 길이가 1인 경우
  if (n < 2) return(vec)
  
  for (i in 1:(n-1)) {
    min_index = i
    for (j in (i+1):n) {
      if (vec[j] < vec[min_index]) {
        min_index = j
      }
    }
    if (min_index != i) {
      temp = vec[i]
      vec[i] = vec[min_index]
      vec[min_index] = temp
    }
  }
  return(vec)
}


set.seed(123)
vec = 3
print(selection_sort(vec))


# 가우스 소거법
gaussian_elimination = function(A, b)
{
  n = nrow(A)
  
  ## 전진 소거
  for (k in 1:(n-1))
  {
    for (i in (k+1):n)
    {
      factor = A[i, k] / A[k, k]
      A[i, k:n] = A[i, k:n] - factor * A[k, k:n]
      b[i] = b[i] - factor * b[k]
    }
  }
  
  ## 후진 대입
  x = numeric(n)
  for (i in n:1)
  {
    if (i < n)
      sum_ax = sum(A[i, (i+1):n] * x[(i+1):n])
    else
      sum_ax = 0 ## 마지막 변수일 경우 sum_ax는 0
    x[i] = (b[i] - sum_ax) / A[i, i]
  }
  return(x)
}


A = matrix(c(3, 1, 2,
             2, -3, 4,
             1, 2, -2),
           nrow = 3, byrow = TRUE)
b = c(5, -3, 6)
solution = gaussian_elimination(A, b)
print(solution)