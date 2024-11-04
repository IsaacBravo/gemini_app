# Load required packages
library(shiny)
library(gemini.R)
library(bslib)
library(fontawesome)

source("llm_prompt_function.R")

# Define the UI
ui <- navbarPage(
  title = "Political Content Analysis with Gemini",
  theme = bs_theme(
    bootswatch = "morph",
    primary = "#2780E3"
  ),
  
  # First tab: Analysis
  tabPanel("Analysis",
           page_sidebar(
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
  ),

  # New tab: Settings or Additional Information
  tabPanel("Scale-Up",
           fluidPage(
             h3("Scale-Up your Analysis"),
             p("This tab allows you to configure in your own environment and scale up your analysis to larger datasets."),
             
             page_sidebar(
               sidebar = sidebar(
                 # title = "Analysis Controls",
                 width = 500,
                 length = 100, 
                 
                 card(
                   height = "800px",
                   padding = "20px",
             
                 # Analysis type selector for scaling up
                 selectInput("scale_type", "Select Analysis Type:", choices = list(
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
                 )),
                 
                 # Options for additional parameters
                 conditionalPanel(
                   condition = "input.scale_type == 'topic_multiple'",
                   numericInput("scale_num_topics", "Number of Topics:", min = 1, value = 3)
                 ),
                 conditionalPanel(
                   condition = "input.scale_type == 'keyword_multiple'",
                   numericInput("scale_num_keywords", "Number of Keywords:", min = 1, value = 3)
                 ),
                 conditionalPanel(
                   condition = "input.scale_type == 'topic_custom'",
                   textInput("scale_topic_list", "Enter Topics (comma-separated):")
                 ),
                 conditionalPanel(
                   condition = "input.scale_type == 'NULL'",
                   textInput("scale_question", "Custom Task Question:")
                 ),
                 actionButton("generate_code", "Generate Code")
                )
               ),
               
               layout_column_wrap(
                 width = 1,
                 card(
                   card_header(
                     class = "bg-primary",
                     "Code for Scaling Up Analysis"
                   ),
                   fill = TRUE,
                   div(
                     # Display the code block with syntax highlighting
                     HTML("<pre style='margin: 0; font-size: 18px;
        line-height: 1.2;'><code class='language-javascript'>"),
                     uiOutput("scale_code"),
                     HTML("</code></pre>")
                   )
                  
                  )
               )
              )
           )
  ),
  

    
  # New tab: Settings or Additional Information
  tabPanel("Settings",
           fluidPage(
             h3("Settings"),
             p("This tab allows you to configure additional settings for the app, such as API keys or custom parameters."),
             textInput("api_key", "Enter your Gemini API Key:", ""),
             actionButton("save_settings", "Save Settings")
           )
  )
)

# Define the server
server <- function(input, output) {
  
  # Display the input text
  output$show_text <- renderText({
    req(input$text)  # Ensure that text input is not empty
    
    # Check if input text is non-empty to prevent rendering invalid content
    if (is.null(input$text) || input$text == "") {
      return("Please enter some text for analysis.")  # Show message if text is empty
    }
    
    # If text is valid, display it
    input$text
  })
  
  # Display the input image
  output$show_image <- renderImage({
    req(input$image)  # Ensure an image file is uploaded
    
    # Check if file path exists to prevent errors
    if (is.null(input$image$datapath) || !file.exists(input$image$datapath)) {
      return(NULL)  # Return NULL if file path is invalid
    }
    
    # Display the image using the file path
    list(
      src = input$image$datapath,
      contentType = input$image$type,
      width = "100%",
      height = "auto"
    )
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
        result <- gemini_image(
          prompt = "Explain this image",
          path = input$image$datapath
        )
      } else {
        result <- "Please upload an image first."
      }
    }
    
    output$result <- renderText({ result })
  })
  
  # Server logic for generating code for larger dataset analysis
  observeEvent(input$generate_code, {
    # Default dataset name for demonstration
    dataset_name <- "large_dataset"
    
    # Initialize code template
    code_template <- ""
    
    # Generate code based on selected analysis type
    if (input$scale_type == "sentiment_single") {
      code_template <- "
      # Example code for Sentiment Single Analysis on Large Dataset
    
      library(gemini.R)
      library(dplyr)
      
      # Import Analysis Function
      source('llm_prompt_function.R')
      
      # Write & Set GEMINI API
      api_key <- 'WRITE API GEMINI KEY'

      setAPI(api_key)
      
      # Import dataset 
      data <- readxl::read_excel('C:\\Users\\Desktop\\data.xlsx')
      
      # Run Sentiment Analysis
      data_results <- apply(data, function(text) {llm_prompt(text = text, type = 'sentiment_single')})
      
      # Note: Implementation llm_prompt function
      
      llm_prompt <- function(text) {
      
        # Define the prompt based on the type of task
        prompt <- switch(type,
                         sentiment_single = paste('Detect the most predominant sentiment 
                         of the following political text in one of the following options 
                         positive, negative or neutral. Only provide the main sentiment 
                         as an answer: ', text)
            )
        
        # Call the Gemini model with the generated prompt
        tryCatch({
          answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
          return(answer)
        }, error = function(e) {
          return('Sorry, I can't answer your question at the moment.')
        })
      }
      
      "
      
    } else if (input$scale_type == "sentiment_multiple") {
      code_template <- "
      # Example code for Sentiment Multiple Analysis on Large Dataset
    
      library(gemini.R)
      library(dplyr)
      
      # Import Analysis Function
      source('llm_prompt_function.R')
      
      # Write & Set GEMINI API
      api_key <- 'WRITE API GEMINI KEY'

      setAPI(api_key)
      
      # Import dataset 
      data <- readxl::read_excel('C:\\Users\\Desktop\\data.xlsx')
      
      # Run Sentiment Analysis
      data_results <- apply(data, function(text) {llm_prompt(text = text, type = 'sentiment_multiple')})
      
      # Note: Implementation llm_prompt function
      
      llm_prompt <- function(text) {
      
        # Define the prompt based on the type of task
        prompt <- switch(type,
                         sentiment_mutiple = paste('Detect the sentiment of the 
                         following political text based on the following options 
                         positive, negative or neutral. Only provide as an answer 
                         each sentiment and its proportion as percentage in the text. 
                         Please do not provide an explanation for your answer: ', text)
            )
        
        # Call the Gemini model with the generated prompt
        tryCatch({
          answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
          return(answer)
        }, error = function(e) {
          return('Sorry, I can't answer your question at the moment.')
        })
      }
      
      "
  
    } else if (input$scale_type == "irony_single") {
      code_template <- "
      # Example code for Irony Detection Analysis on Large Dataset
    
      library(gemini.R)
      library(dplyr)
      
      # Import Analysis Function
      source('llm_prompt_function.R')
      
      # Write & Set GEMINI API
      api_key <- 'WRITE API GEMINI KEY'

      setAPI(api_key)
      
      # Import dataset 
      data <- readxl::read_excel('C:\\Users\\Desktop\\data.xlsx')
      
      # Run Sentiment Analysis
      data_results <- apply(data, function(text) {llm_prompt(text = text, type = 'sentiment_multiple')})
      
      # Note: Implementation llm_prompt function
      
      llm_prompt <- function(text) {
      
        # Define the prompt based on the type of task
        prompt <- switch(type,
                         irony_single = paste('Detect the most predominant irony 
                         levels from the following political. Provide the answer 
                         with the option is_irony or no_irony. Only provide the 
                         main option as an answer:', text)
            )
        
        # Call the Gemini model with the generated prompt
        tryCatch({
          answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
          return(answer)
        }, error = function(e) {
          return('Sorry, I can't answer your question at the moment.')
        })
      }      
      "
      
    } else if (input$scale_type == "irony_multiple") {
      code_template <- "
      # Example code for Irony Detection Analysis on Large Dataset
    
      library(gemini.R)
      library(dplyr)
      
      # Import Analysis Function
      source('llm_prompt_function.R')
      
      # Write & Set GEMINI API
      api_key <- 'WRITE API GEMINI KEY'

      setAPI(api_key)
      
      # Import dataset 
      data <- readxl::read_excel('C:\\Users\\Desktop\\data.xlsx')
      
      # Run Sentiment Analysis
      data_results <- apply(data, function(text) {llm_prompt(text = text, type = 'sentiment_multiple')})
      
      # Note: Implementation llm_prompt function
      
      llm_prompt <- function(text) {
      
        # Define the prompt based on the type of task
        prompt <- switch(type,
                         irony_multiple = paste('Detect the irony levels from the 
                         following political text. Provide the answer with the option 
                         is_irony and no_irony and its proportion as percentage in the 
                         text. Only provide as an answer each option and its proportion 
                         as percentage in the text: ', text)
            )
        
        # Call the Gemini model with the generated prompt
        tryCatch({
          answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
          return(answer)
        }, error = function(e) {
          return('Sorry, I can't answer your question at the moment.')
        })
      }        
      "
      
    } else if (input$scale_type == "hate_speech_single") {
      code_template <- "
      # Example code for Hate Speech Detection Analysis on Large Dataset
    
      library(gemini.R)
      library(dplyr)
      
      # Import Analysis Function
      source('llm_prompt_function.R')
      
      # Write & Set GEMINI API
      api_key <- 'WRITE API GEMINI KEY'

      setAPI(api_key)
      
      # Import dataset 
      data <- readxl::read_excel('C:\\Users\\Desktop\\data.xlsx')
      
      # Run Sentiment Analysis
      data_results <- apply(data, function(text) {llm_prompt(text = text, type = 'sentiment_multiple')})
      
      # Note: Implementation llm_prompt function
      
      llm_prompt <- function(text) {
      
        # Define the prompt based on the type of task
        prompt <- switch(type,
                         hate_speech_single = paste('Detect the most predominant Hate Speech 
                         levels from the following political. Provide the answer with the 
                         option is_hate_speech or no_hate_speech Only provide the main option 
                         as an answer: ', text)
            )
        
        # Call the Gemini model with the generated prompt
        tryCatch({
          answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
          return(answer)
        }, error = function(e) {
          return('Sorry, I can't answer your question at the moment.')
        })
      }      
      
      "
      
    } else if (input$scale_type == "hate_speech_multiple") {
      code_template <- "
      # Example code for Hate Speech Detection Analysis on Large Dataset
    
      library(gemini.R)
      library(dplyr)
      
      # Import Analysis Function
      source('llm_prompt_function.R')
      
      # Write & Set GEMINI API
      api_key <- 'WRITE API GEMINI KEY'

      setAPI(api_key)
      
      # Import dataset 
      data <- readxl::read_excel('C:\\Users\\Desktop\\data.xlsx')
      
      # Run Sentiment Analysis
      data_results <- apply(data, function(text) {llm_prompt(text = text, type = 'sentiment_multiple')})
      
      # Note: Implementation llm_prompt function
      
      llm_prompt <- function(text) {
      
        # Define the prompt based on the type of task
        prompt <- switch(type,
                         hate_speech_multiple = paste('Detect the Hate Speech levels 
                         of the following political text. Provide the answer with the 
                         option is_hate_speech and no_hate_speech and its proportion 
                         as percentage in the text. Only provide as an answer each option 
                         and its proportion as percentage in the text: ', text)
            )
        
        # Call the Gemini model with the generated prompt
        tryCatch({
          answer <- gemini(prompt) # Assuming 'gemini' is a valid function to call the API
          return(answer)
        }, error = function(e) {
          return('Sorry, I can't answer your question at the moment.')
        })
      }      
      
      "
      
      
      
    } else if (is.null(input$scale_type)) {
      code_template <- ""
      
    } else if (is.null(input$scale_type)) {
      code_template <- ""
      
    }
    
    
    output$scale_code <- renderUI({
      # Wrap the code in <code> and <pre> tags for Prism.js to highlight
      HTML(paste0("<code class='language-javascript'>", code_template, "</code>"))
    })
  })
  
  
  # Save settings in the Settings tab
  observeEvent(input$save_settings, {
    # Here you can add code to save the API key or other settings
    # For example, save it to a global variable or write to a config file
    message("Settings saved: ", input$api_key)
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)
