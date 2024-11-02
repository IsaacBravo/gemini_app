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
