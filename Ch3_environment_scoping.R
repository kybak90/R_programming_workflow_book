# 환경(Environment)
library(pryr)
parenvs(all = TRUE)

library(dplyr)

search()


# 환경 트리 구조 확인
parenvs(all=TRUE)

parent.env(globalenv())

as.environment("package:dplyr")


# 함수 범위(Scope) 및 실행 환경(Environment)
nums = 1:5

## 버전 1: 함수 내부에서 nums를 새로 정의
add_numbers = function()
{
  nums = 1:10
  sum_nums = sum(nums)
  return(list(value = sum_nums,
              runtime_env = environment(),
              parent_env = parent.env(environment()),
              objects_env = ls.str(environment())
  ))
}
add_numbers()

environment(add_numbers)
print(nums)



## 버전 2: 전역 환경의 nums를 사용하는 함수
add_numbers_2 = function()
{
  sum_nums = sum(nums)
  return(sum_nums)
}
add_numbers_2()



## 버전 3: 인자로 받은 nums를 수정하여 반환
nums = 1:5
modify_nums = function(nums)
{
  nums = nums + 1
  return(nums)
}
nums = modify_nums(nums = nums)
nums