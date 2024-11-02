# Load the required packages
library(shiny)
library(gemini.R)



# Source the llm_prompt function from the file
# source("llm_prompt_function.R")

# Define the UI
ui <- fluidPage(
  titlePanel("Political Text Analysis with Gemini"),
  sidebarLayout(
    sidebarPanel(
      textInput("text", "Enter Political Text:", ""),
      selectInput("type", "Select Analysis Type:", choices = list(
        "Sentiment Single" = "sentiment_single",
        "Sentiment Multiple" = "sentiment_multiple",
        "Irony Single" = "irony_single",
        "Irony Multiple" = "irony_multiple",
        "Hate Speech Single" = "hate_speech_single",
        "Hate Speech Multiple" = "hate_speech_multiple",
        "Offensive Language Single" = "offensive_lang_single",
        "Offensive Language Multiple" = "offensive_lang_multiple",
        "Emotion Single" = "emotion_single",
        "Emotion Multiple" = "emotion_multiple",
        "Topic Top" = "topic_top",
        "Topic Multiple" = "topic_multiple",
        "Topic Custom" = "topic_custom",
        "Keyword Single" = "keyword_single",
        "Keyword Multiple" = "keyword_multiple",
        "Entities" = "entities",
        "Custom Task" = NULL
      )),
      conditionalPanel(
        condition = "input.type == 'topic_multiple'",
        numericInput("num_topics", "Number of Topics:", min = 1, value = 3)
      ),
      conditionalPanel(
        condition = "input.type == 'keyword_multiple'",
        numericInput("num_keywords", "Number of Keywords:", min = 1, value = 3)
      ),
      conditionalPanel(
        condition = "input.type == 'topic_custom'",
        textInput("topic_list", "Enter Topics (comma-separated):")
      ),
      conditionalPanel(
        condition = "input.type == NULL",
        textInput("question", "Custom Task Question:")
      ),
      actionButton("analyze", "Analyze Text")
    ),
    mainPanel(
      h3("Analysis Result"),
      verbatimTextOutput("result")
    )
  )
)

# Define the server
server <- function(input, output) {
  
  # Reactive expression to run llm_prompt based on user input
  observeEvent(input$analyze, {
    # Capture user inputs
    text <- input$text
    type <- input$type
    question <- if (is.null(type)) input$question else NULL
    num_topics <- if (type == "topic_multiple") input$num_topics else NULL
    num_keywords <- if (type == "keyword_multiple") input$num_keywords else NULL
    topic_list <- if (type == "topic_custom") unlist(strsplit(input$topic_list, ",")) else NULL
    
    # Call the llm_prompt function and display the result
    result <- llm_prompt(
      text = text, 
      question = question, 
      type = type, 
      num_topics = num_topics, 
      num_keywords = num_keywords, 
      topic_list = topic_list
    )
    output$result <- renderText({ result })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
