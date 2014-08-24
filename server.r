library(ggvis)
library(dplyr)

repos  <- read.csv('./results-r-all.csv',
                  colClasses=c("POSIXct","POSIXct","character",
                               "integer","integer","integer",
                               "character","character","logical",
                               "logical","logical","integer",
                               "integer","POSIXct"))

all_repos  <- tbl_df(repos)

shinyServer(function(input, output, session) {
  
  # Filter the movies, returning a data frame
  repos <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    start_date <- input$Date[1]
    end_date <- input$Date[2]
    stars <- input$Stars
    forks <- input$Forks
    watchers <- input$Watchers
    issues <- input$Issues
    size <- input$Size

    # Apply filters
    m <- all_repos %>%
      filter(
        as.Date(start_dt) >= start_date,
        as.Date(end_dt) <= end_date,
        num_stars >= stars,
        repository_forks_max >= forks,
        repository_watchers >= watchers,
        repository_open_issues_max >= issues,
        repository_size_max >= size
      ) %>%
      arrange(repository_forks_max)

     # Optional: filter by description keyword
     if (!is.null(input$keyword) && input$keyword != "") {
       keyword <- paste0("%", input$keyword, "%")
       m <- m %>% filter(repository_description %like% keyword)
     }
    
    m <- as.data.frame(m)
    
    # Add column which says whether the movie won any Oscars
    # Be a little careful in case we have a zero-row data frame
     m$has_wiki <- character(nrow(m))
     m$has_wiki[m$repository_has_wiki == FALSE] <- "No"
     m$has_wiki[m$repository_has_wiki >= TRUE] <- "Yes"
    m
  })
  
  # Function for generating tooltip text
  repo_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$repository_url)) return(NULL)
    
    # Pick out the repo with this ID
    all_repos <- isolate(repos())
    repo <- all_repos[all_repos$repository_url == x$repository_url, ]

    paste0("<b>", repo$repository_name, "</b><br>",
       "Created: ", as.Date(repo$repository_created_at), "<br>",
       "Stars:", format(repo$num_stars, big.mark = ",", scientific = FALSE)
    )
  }
  
  # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    ggvis(repos, x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~has_wiki, key := ~repository_url) %>%
      add_tooltip(repo_tooltip, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name) %>%
      add_legend("stroke", title = "Has Wiki", values = c("Yes", "No")) %>%
      scale_nominal("stroke", domain = c("Yes", "No"),
                    range = c("orange", "#aaa")) %>%
      set_options(width = 500, height = 500) 
    })    
  
  vis %>% bind_shiny("plot1")
  
  output$n_repos <- renderText({ nrow(repos()) })
})
