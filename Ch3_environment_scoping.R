# 환경(Environment)

# 기존 예제에서는 pryr::parenvs()로 환경의 부모 관계를 확인했음.
# pryr는 현재 다른 패키지로 대체된 상태(superseded)이며,
# 2026-01-30에 CRAN에서 보관 처리(archived)되었음.
# 따라서 이 예제에서는 rlang::env_parents()를 사용함.

# install.packages("rlang")  # 설치되어 있지 않으면 한 번 실행

# 기존 코드
# library(pryr)
# parenvs(all = TRUE)

# 전역 환경과 그 부모 환경들을 확인
# env_parents()는 시작 환경 자체를 제외하고 부모 환경들만 반환함.
globalenv()
rlang::env_parents(globalenv(), last = emptyenv())

library(dplyr)

# 패키지 연결 후 검색 경로 확인
search()

# 환경의 부모 연결 구조 확인
# last = emptyenv()는 빈 환경까지 부모 관계를 따라가도록 지정함.
rlang::env_parents(globalenv(), last = emptyenv())

# 전역 환경의 바로 위 부모 환경
parent.env(globalenv())

# 검색 경로에 연결된 dplyr 패키지 환경
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
