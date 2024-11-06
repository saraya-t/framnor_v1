

# Module UI function
mod_what_is_biosecurity_ui <- function(id) {
  ns <- shiny::NS(id)
  
  shiny::tagList(
    tabBox(
      title = "", id = "be", width = 12,
      tabPanel(
        "What is biosecurity",
        div(style = "max-width:900px; margin: 0 auto;",
            includeHTML("www/what_is_biosecurity_1.html")),
        div(style = "max-width:480px; margin: 0 auto;",
            HTML(paste0('<video width="480" height="360" controls>',
                        '<source src="Module 5 - Disease control and biosecurity.mp4" type="video/mp4">',
                        'Your browser does not support the video tag.',
                        '</video>')))),
      tabPanel("Biosecurity Evaluation", div(
        style = "max-width:900px; margin: 0 auto;",
        includeHTML("www/what_is_biosecurity_2.html")))),
  if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton(ns("browse"), "Browse")}
  )
}

# Module server function
mod_what_is_biosecurity_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    
    shiny::observeEvent(input$browse, { browser() })
    

    # output$be <- renderUI({
    #   includeHTML(
    #     rmarkdown::render(
    #       input  = "report_template.Rmd", 
    #       params = list(selection = input$state, data=librarians_filtered)
    #     )
    #   )
    # })
    
    # - 'What is biosecurity' new document with text. Create tabpanels for content, the content into RMarkdown documents. Just 2 tabs:
    #   - What is biosecurity (tabname)
    #     + What is biosecurity (header)
    #     + Importance of biosecurity (header)
    #     + Video (370MB, make small version for development or Youtube: https://drive.google.com/drive/folders/1kWXi3ECBY5V9-sUIp6EQEu1LbjPET89d)
    #   - Biosecurity Evaluation (tabname)
    #     + External biosecurity (header)
    #       > (sub-headers)
    #     + Internal biosecurity (header) 
    #       > (sub-headers)
    #     + References (header)
    
  })
}