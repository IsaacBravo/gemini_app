# Load the required packages
library(shiny)

llm_prompt <- function(text, question = NULL, type = NULL, num_topics = NULL, num_keywords = NULL, topic_list = NULL) {
  # Define the prompt based on the type of task
  prompt <- switch(type,
                   sentiment_single = paste("Detect the most predominant sentiment of the following political text in one of the following options positive, negative or neutral. Only provide the main sentiment as an answer: ", text),
                   sentiment_multiple = paste("Detect the sentiment of the following political text based on the following options positive, negative or neutral. Only provide as an answer each sentiment and its proportion as percentage in the text. Please do not provide an explanation for your answer: ", text),
                   irony_single = paste("Detect the most predominant irony levels from the following political. Provide the answer with the option is_irony or no_irony. Only provide the main option as an answer: ", text),
                   irony_multiple = paste("Detect the irony levels from the following political text. Provide the answer with the option is_irony and no_irony and its proportion as percentage in the text. Only provide as an answer each option and its proportion as percentage in the text: ", text),
                   hate_speech_single = paste("Detect the most predominant Hate Speech levels from the following political. Provide the answer with the option is_hate_speech or no_hate_speech Only provide the main option as an answer: ", text),
                   hate_speech_multiple = paste("Detect the Hate Speech levels of the following political text. Provide the answer with the option is_hate_speech and no_hate_speech and its proportion as percentage in the text. Only provide as an answer each option and its proportion as percentage in the text: ", text),             
                   offensive_lang_single = paste("Detect the most predominant Offensive Language levels from the following political. Provide the answer with the option is_offensive or non_offensive Only provide the main option as an answer: ", text),
                   offensive_lang_multiple = paste("Detect the Offensive Language levels of the following political text. Provide the answer with the option is_offensive and non_offensive and its proportion as percentage in the text. Only provide as an answer each option and its proportion as percentage in the text: ", text),             
                   emotion_single = paste("Detect the most predominant emotion of the following political text in one of the following options anticipation, disgust, fear, joy, love, optimism, pessimism, sadness, surprise or trust. Only provide the main emotion as an answer: ", text),
                   emotion_multiple = paste("Detect the emotions of the following political text based on the following options anticipation, disgust, fear, joy, love, optimism, pessimism, sadness, surprise or trust. Only provide as an answer each emotion and its proportion as percentage in the text: ", text),
                   topic_top = paste("Detect the most predominant topic from the following political text. Only provide as an answer the name of the topic. Please do not provide description about the topic: ", text),
                   topic_multiple = if (!is.null(num_topics)) {
                     paste("Detect the most predominant", num_topics, "topics from the following political text. Only provide as an answer the name of each topic and its proportion as percentage in the text. Please do not provide description about the topic: ", text)
                   } else {
                     stop("num_topics must be specified for topic_multiple")
                   },
                   topic_custom = if (!is.null(topic_list)) {
                     paste("Detect the most predominant topics from the following political text. Use the following topics to identify them in the text ", topic_list, ". Only provide as an answer the name of each topic and its proportion as percentage in the text. Please do not provide description about the topic: ", text)
                   } else {
                     stop("topic_list must be specified for topic_custom")
                   },
                   keyword_single = paste("Detect the most predominant keyword from the following political text. Only provide as an answer the name of the keyword: ", text),
                   keyword_multiple = if (!is.null(num_keywords)) {
                     paste("Detect the most predominant", num_keywords, "keyword(s) from the following political text. Only provide as an answer the name of each keyword. Please do not provide description about the keyword: ", text)
                   } else {
                     stop("num_keywords must be specified for keyword_multiple")
                   },
                   
                   entities = paste("Detect, extract and list any key entities (e.g., people, organizations, locations) mentioned in the following political text. Only provide as an answer the name of each entities and its entity name: ", text),
                   
                   # Default case if type is not recognized
                   question_task = paste(
                     "You are a social scientist working on a research project on political science and communication. Here is a political text for your analysis: ", text, ". Your task is: ", question
                   )
  )
  
  # Call the Gemini model with the generated prompt
  tryCatch({
    answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
    return(answer)
  }, error = function(e) {
    return("Sorry, I can't answer your question at the moment.")
  })
}


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
