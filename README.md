# Political Content Analysis with Gemini

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shiny](https://img.shields.io/badge/built%20with-R%20Shiny-green)
![Gemini API](https://img.shields.io/badge/API-Gemini-orange)

This Shiny app provides an interactive platform for performing text and image analysis related to political content using the Gemini API. Users can analyze text for sentiment, irony, hate speech, emotions, topics, and keywords, or upload an image for description, entity recognition, arousal, and valence analysis.

## Features

- **Text Analysis**: Analyze text for sentiment, irony, hate speech, emotions, topics, keywords, and entities.
- **Image Analysis**: Upload images for analysis to generate captions, identify entities, analyze colors, and assess arousal and valence levels.
- **User-friendly Interface**: Choose between text and image input types, select analysis options, and view results in real-time.

## Technologies

- **R Shiny**: Web application framework for R.
- **Gemini API**: API used for text and image analysis.
- **bslib**: Bootstrap theming for a polished interface.
- **fontawesome**: Icon support for enhanced UI experience.

## Getting Started

### Prerequisites

- **R** (version 4.0 or higher)
- **RStudio** (optional but recommended for development)
- **R Packages**: Ensure you have the following packages installed:
  - `shiny`
  - `gemini.R`
  - `bslib`
  - `fontawesome`

Install missing packages in R:

```r
install.packages(c("shiny", "gemini.R", "bslib", "fontawesome"))
```

### Gemini API Key

1. Obtain an API key for Gemini.
2. In the app code, set your API key:
```r
setAPI("YOUR_KEY")
```

## Citation

Please cite TextAnalyzer if you use it for your publications:

      Isaac Bravo (2024). Gemini in R: A Shiny Application for Automatic Image and Text Analysis using Gemini API
      https://github.com/IsaacBravo/gemini_app

A BibTeX entry for LaTeX users is:

      @Manual{,
        title = {TextAnalyzer: Gemini in R: A Shiny Application for Automatic Image and Text Analysis using Gemini API},
        author = {Isaac Bravo},
        year = {2024},
        url = {https://github.com/IsaacBravo/gemini_app},
      }



