library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(fluidPage(
  titlePanel("R - Repository Browser"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput("Stars", "Number of starts received",
                    0, 1600, value= c(0, 1000)),
        dateRangeInput("Date", "Date range:",
                    start = "2012-01-01"),
        sliderInput("Forks", "Number of Forks",
                    0, 1000, value=c(0,400)),
        sliderInput("Watchers", "Number of Watchers",
                    0, 1000, value=c(0,400)),
        sliderInput("Issues", "Number of open issues",
                    0, 300, value=c(0,300)),
        sliderInput("Size", "Size of repository",
                    0, 1500000, value=c(0,1500000)),
        textInput("keyword", "Description contains (e.g., Coursera)")
      ),
      wellPanel(
        selectInput("xvar", "X-axis variable", axis_vars, selected = "num_stars"),
        selectInput("yvar", "Y-axis variable", axis_vars, selected = "repository_forks_max"),
        tags$small(paste0(
          "Note: The source data is downloaded from Google Big Query",
          "GitHub Archive dataset is also available via Google BigQuery"
        ))
      )
    ),
    column(9,
      ggvisOutput("plot1"),
      wellPanel(
        span("Number of repositories selected:",
          textOutput("n_repos")
        )
      )
    )
  )
))
