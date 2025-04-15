#install.packages("shiny")
library(shiny)

# Shiny 기본 템플릿
## 히스토그램을 그리는 애플리케이션의 UI 정의
ui = fluidPage(
  ### 애플리케이션 제목
  titlePanel("Old Faithful Geyser Data"),
  
  ### 슬라이더 입력을 포함하는 사이드바 레이아웃
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    ### 생성된 분포를 보여주는 메인 패널
    mainPanel(
      plotOutput("distPlot")
    )
  )
)


## 히스토그램을 그리기 위한 서버 로직 정의
server = function(input, output) {
  output$distPlot = renderPlot({
    
    ### ui에서 입력받은 input$bins 값을 기준으로 구간 생성
    x = faithful[, 2]
    bins = seq(min(x), max(x), length.out = input$bins + 1)
    
    ### 지정된 구간 수로 히스토그램 그리기
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')})
}


## 애플리케이션 실행
shinyApp(ui = ui, server = server)



# 반응형 프로그래밍
reactiveData = reactive({
  faithful[, 2] * input$bins
})