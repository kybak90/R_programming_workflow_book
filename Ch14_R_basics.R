#install.packages(c("ggplot2", "palmerpenguins"))

# 경로 관리
getwd()

# R 객체
## 벡터
### 수치형 벡터
odd = c(1, 3, 5, 7, 9)
odd
typeof(odd)


odd_L = c(1L, 3L, 5L, 7L, 9L)
odd_L
typeof(odd_L)


### 문자형 벡터
txt = c("Advanced", "R", "Book")
txt
typeof(txt)


### 논리형 벡터
3.14 > 3
logic = c(FALSE, TRUE)
logic
typeof(logic)



## 행렬
vec = c(1:10)
vec
mat = matrix(vec, nrow = 2, ncol = 5)
mat


mat1 = matrix(vec, nrow = 2, ncol = 5, byrow = TRUE)
mat1


## 배열
arr = array(1:30, dim = c(3, 5, 2))
arr



## 리스트
lst = list(name = "Alice",
           age = 25,
           subject = c("math", "science", "english"),
           score = matrix(c(90, 85, 88, 75, 83, 90),
                          nrow = 2,
                          dimnames = list(c("Midterm", "Final"),
                                          c("math", "science", "english"))))
lst



## 데이터 프레임
df = data.frame(Name = c("Alice", "Bob", "Charlie"),
                Age = c(25, 30, 35),
                Score = c(90, 93, 88))
df

df$Age   # Age 열에 접근
df[[2]]  # 두 번째 열에 접근
df[1, ]  # 첫 번째 행에 접근
df[2, 1] # 두 번째 행, 첫 번째 열에 접근





# 반복문과 조건문
## 반복문 기초 문법
for (i in 1:5)
{
  print(i)
}



for (string in c("advanced", "R", "book", "study"))
{
  print(string)
}



i = 1
while (i <= 5)
{
  print(i)
  i = i + 1
}



num = -5
if (num > 0)
{
  print("positive")
} else if (num < 0)
{
  print("negative")
} else
{
  print("zero")
}


## 조건문 기초 문법
num = -5
if (num > 0)
{
  print("positive")
} else if (num < 0)
{
  print("negative")
} else
{
  print("zero")
}



## 함수 정의 및 호출

add_numbers = function(x, y) ### 함수 정의
{
  sum = x + y
  return(sum)
}
result = add_numbers(3, 5) ### 함수 호출
print(result)





greet = function(name = "사용자") ### 함수 정의
{
  return(paste("안녕하세요,", name, "!"))
}
greet() ### 함수 호출
greet("철수")