library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(fluidPage(
  titlePanel("Repositories explorer"),
  fluidRow(
    column(3,
      wellPanel(
        h4("Filter"),
        sliderInput("Stars", "Minimum number of starts received",
          10, 300, 80, step = 10),
        dateRangeInput("Date", "Date range:",
                       start = "2001-01-01"),
        sliderInput("Forks", "Minimum number of Forks",
          0, 50, 0, step = 1),
        sliderInput("Watchers", "Minimum number of Watchers",
                    0, 50, 0, step = 1),
        sliderInput("Issues", "Minimum number of open issues",
          0, 100, 0, step = 1),
        sliderInput("Size", "Size of repository",
          0, 100, 0, step = 1),

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
