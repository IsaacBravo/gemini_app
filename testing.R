# Load the required packages
library(shiny)
library(gemini.R)
library(bslib)
library(fontawesome)

source("llm_prompt_function.R")

# Define the UI
ui <- page_sidebar(
  theme = bs_theme(
    bootswatch = "morph",
    primary = "#2780E3"
  ),
  
  title = "Political Content Analysis with Gemini",
  sidebar = sidebar(
    title = "Analysis Controls",
    width = 500,
    length = 500,
    
    
    card(
      height = "800px",
      padding = "20px",
      
      # Add input type selector
      radioButtons("input_type", "Select Input Type:",
                   choices = c("Text" = "text", "Image" = "image"),
                   selected = "text"),
      
      # Conditional panel for text input
      conditionalPanel(
        condition = "input.input_type == 'text'",
        textAreaInput("text", "Enter Text:", "", height = "200px")
      ),
      
      # Conditional panel for image input
      conditionalPanel(
        condition = "input.input_type == 'image'",
        fileInput("image", "Upload Image:",
                  accept = c('image/png', 'image/jpeg', 'image/jpg'))
      ),
      
      # Conditional panel for text analysis types
      conditionalPanel(
        condition = "input.input_type == 'text'",
        selectInput("type", "Select Analysis Type:", choices = list(
          "Sentiment Analysis" = list(
            "Sentiment Single" = "sentiment_single",
            "Sentiment Multiple" = "sentiment_multiple"
          ),
          "Irony Detection" = list(
            "Irony Single" = "irony_single",
            "Irony Multiple" = "irony_multiple"
          ),
          "Content Moderation" = list(
            "Hate Speech Single" = "hate_speech_single",
            "Hate Speech Multiple" = "hate_speech_multiple",
            "Offensive Language Single" = "offensive_lang_single",
            "Offensive Language Multiple" = "offensive_lang_multiple"
          ),
          "Emotion Analysis" = list(
            "Emotion Single" = "emotion_single",
            "Emotion Multiple" = "emotion_multiple"
          ),
          "Topic Analysis" = list(
            "Topic Top" = "topic_top",
            "Topic Multiple" = "topic_multiple",
            "Topic Custom" = "topic_custom"
          ),
          "Keyword Analysis" = list(
            "Keyword Single" = "keyword_single",
            "Keyword Multiple" = "keyword_multiple"
          ),
          "Other" = list(
            "Entities" = "entities",
            "Custom Task" = NULL
          )
        ))
      ),
      
      # Conditional panel for image analysis types
      conditionalPanel(
        condition = "input.input_type == 'image'",
        selectInput("img_type", "Select Image Analysis Type:", choices = list(
          "Description" = "caption_description",
          "Single Entity" = "entity_single",
          "Multiple Entities" = "entity_multiple",
          "Arousal Level" = "arousal_level",
          "Valence Level" = "valence_level",
          "Color Analysis" = "color_caption"
        ))
      ),
      
      conditionalPanel(
        condition = "input.input_type == 'text' && input.type == 'topic_multiple'",
        numericInput("num_topics", "Number of Topics:", min = 1, value = 3)
      ),
      conditionalPanel(
        condition = "input.input_type == 'text' && input.type == 'keyword_multiple'",
        numericInput("num_keywords", "Number of Keywords:", min = 1, value = 3)
      ),
      conditionalPanel(
        condition = "input.input_type == 'text' && input.type == 'topic_custom'",
        textInput("topic_list", "Enter Topics (comma-separated):")
      ),
      conditionalPanel(
        condition = "input.input_type == 'text' && input.type == 'NULL'",
        textInput("question", "Custom Task Question:")
      ),
      br(),
      actionButton("analyze", "Analyze Content", class = "btn-primary w-100",
                   icon = icon("magnifying-glass"))
    )
  ),
  
  layout_column_wrap(
    width = .5,
    card(
      card_header(
        class = "bg-primary",
        "Input Content"
      ),
      fill = TRUE,
      # Conditional panel for showing text input
      conditionalPanel(
        condition = "input.input_type == 'text'",
        HTML(
          paste0(
            "<div style='padding: 15px; font-size: 20px;'>",
            textOutput("show_text", inline = TRUE),
            "</div>"
          ))
      ),
      # Conditional panel for showing image input
      conditionalPanel(
        condition = "input.input_type == 'image'",
        imageOutput("show_image")
      )
    ),
    card(
      card_header(
        class = "bg-primary",
        "Analysis Result"
      ),
      fill = TRUE,
      HTML(
        paste0(
          "<div style='padding: 15px; font-size: 20px;'>",
          textOutput("result", inline = TRUE),
          "</div>"
        ))
    )
  )
)

# Define the server
server <- function(input, output) {
  
  # Display the input text
  output$show_text <- renderText({
    if (!is.null(input$text)) input$text
  })
  
  # Display the input image
  output$show_image <- renderImage({
    if (!is.null(input$image)) {
      list(
        src = input$image$datapath,
        contentType = input$image$type,
        width = "100%",
        height = "auto"
      )
    }
  }, deleteFile = FALSE)
  
  # Reactive expression to run analysis based on user input
  observeEvent(input$analyze, {
    if (input$input_type == "text") {
      # Text analysis
      content <- input$text
      type <- input$type
      question <- if (is.null(type)) input$question else NULL
      num_topics <- if (type == "topic_multiple") input$num_topics else NULL
      num_keywords <- if (type == "keyword_multiple") input$num_keywords else NULL
      topic_list <- if (type == "topic_custom") unlist(strsplit(input$topic_list, ",")) else NULL
      
      result <- llm_prompt(
        text = content,
        question = question,
        type = type,
        num_topics = num_topics,
        num_keywords = num_keywords,
        topic_list = topic_list
      )
    } else {
      # Image analysis
      if (!is.null(input$image)) {
        result <- llm_prompt_img(
          image_path = input$image$datapath,
          type = input$img_type
        )
      } else {
        result <- "Please upload an image first."
      }
    }
    
    output$result <- renderText({ result })
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
