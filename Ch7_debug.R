# 예제 함수
## 로지스틱 곡선 생성 함수 
logistic = function(a)
{
  return(1 / (1 + exp(-a)))
}


## 가중 최소제곱법
wls = function(X, y, W = NULL)
{
  if (is.null(W))
    W = diag(1, length(y))
  return(solve(t(X) %*% W %*% X, t(X) %*% W %*% y))
}


## IRLS 알고리즘
glm_irls = function(X, y, max_iter = 1000, epsilon = 1e-8)
{
  p = ncol(X)
  beta_hat = beta_hat_old = rep(1, p)
  diff = 1
  iter = 1
  
  while((diff > epsilon) & (iter < max_iter))
  {
    iter = iter + 1
    beta_hat_old = beta_hat
    
    y_hat = logistic(X %*% beta_hat)
    y_hat_prod = y_hat * (1 - y_hat)
    W = diag(as.vector(y_hat_prod))
    z = (y - y_hat) / y_hat_prod
    
    beta_hat = beta_hat + wls(X, z, W)
    diff = sum((beta_hat - beta_hat_old)^2)
  }
  return(beta_hat)
}


## 데이터 생성
set.seed(923)
n = 1000
x1 = runif(n)
x2 = runif(n)
X = matrix(c(rep(1, n), x1, x2), nrow = n)
beta = c(1, 3, -2)
y = rbinom(n, size = 1, prob = logistic(X %*% beta))

## IRLS 추정치
beta_est = glm_irls(X, y)
as.vector(beta_est)

## glm() 함수를 이용한 적합
glm(y ~ x1 + x2, family = binomial())$coefficients



# traceback()을 사용한 디버깅
wls = function(X, y, W = NULL)
{
  if (is.null(W))
    W = diag(1, length(y))
  
  return(solve(t(X) %*% Wt %*% X, t(X) %*% Wt %*% y))
}


beta_est = glm_irls(X, y)
traceback()


# browser()를 사용한 디버깅
wls = function(X, y, W = NULL)
{
  if (is.null(W))
    W = diag(1, length(y))
  
  return(solve(t(X) %*% W %*% X, t(X) %*% W %*% y))
}


glm_irls = function(X, y, max_iter = 1000, epsilon = 1e-8)
{
  p = ncol(X)
  beta_hat = beta_hat_old = rep(1, p)
  
  browser() # 디버깅 모드 진입
  
  diff = 1
  iter = 1
  
  while((diff > epsilon) & (iter < max_iter))
  {
    iter = iter + 1
    beta_hat_old = beta_hat
    
    y_hat = logistic(X %*% beta_hat)
    y_hat_prod = y_hat * (1 - y_hat)
    W = diag(as.vector(y_hat_prod))
    z = (y - y_hat) / y_hat_prod
    
    beta_hat = beta_hat + wls(X, z, W)
    diff = sum((beta_hat - beta_hat_old)^2)
  }
  return(beta_hat)
}
glm_irls(X, y, max_iter = 2)




# debug()와 debugonce()를 사용한 디버깅
glm_irls = function(X, y, max_iter = 1000, epsilon = 1e-8)
{
  p = ncol(X)
  beta_hat = beta_hat_old = rep(1, p)
  
  diff = 1
  iter = 1
  
  while((diff > epsilon) & (iter < max_iter))
  {
    iter = iter + 1
    beta_hat_old = beta_hat
    
    y_hat = logistic(X %*% beta_hat)
    y_hat_prod = y_hat * (1 - y_hat)
    W = diag(as.vector(y_hat_prod))
    z = (y - y_hat) / y_hat_prod
    
    beta_hat = beta_hat + wls(X, z, W)
    diff = sum((beta_hat - beta_hat_old)^2)
  }
  return(beta_hat)
}

debug(glm_irls)
glm_irls(X, y, max_iter = 2)
undebug(glm_irls)



debugonce(glm_irls)
glm_irls(X, y, max_iter = 2) # 디버깅 모드 진입
glm_irls(X, y, max_iter = 2) # 디버깅 과정 없이 코드 실행






