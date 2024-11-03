library(imager)

plot(load.image(img_path))

img_path <- "./2aplfkb8.png"

gemini_image(prompt = "Explain this image in one sentence", image = img_path)





llm_prompt_img(img_path, type = "caption_description")
llm_prompt_img(img_path, type = "entity_single")
llm_prompt_img(img_path, type = "entity_multiple")
llm_prompt_img(img_path, type = "arousal_level")
llm_prompt_img(img_path, type = "valence_level")
llm_prompt_img(img_path, type = "color_caption")



