

ui <- dashboardPage(
  options = list(sidebarExpandOnHover = TRUE),
  header = dashboardHeader(),
  sidebar = dashboardSidebar(
    minified = TRUE, collapsed = TRUE, id = "sidebar",
    div(style = "height:180px;",
        img(src = "logo_name_tall.png", width = "80%", style = "display: block; margin:auto;")),
    sidebarMenu(
      id = "main_menu",
      menuItem("Biosecurity Evaluation Tools", tabName = "biosecurity_evaluation", icon = icon("clipboard")),
      menuItem("What is Biosecurity in Aquaculture", tabName = "what_is_biosecurity", icon = icon("shield")),
      menuItem("Summary statistics", tabName = "summary_statistics", icon = icon("bar-chart")),
      menuItem("Risk profiling", tabName = "risk_factors", icon = icon("exclamation")),
      menuItem("Project Framnor", tabName = "home", icon = icon("home"))
    ), 
    if (Sys.getenv("BROWSE") == "TRUE") { shiny::actionButton("browse", "Browse")},
    div(style = "position: fixed; bottom: 0;margin-left:-10px;", 
        if (Sys.getenv("LOCAL_DATA") == "FALSE") { 
          actionButton("refresh_btn", label = NULL, icon = icon("refresh")) 
        })
  ),
  body = dashboardBody(
    tags$head(
      tags$style(HTML("
      p { font-size: 16px; }"))
    ),
    customTheme,
    tabItems(
      tabItem(tabName = "home", mod_home_ui("home")),
      tabItem(tabName = "what_is_biosecurity", mod_what_is_biosecurity_ui("what_is_biosecurity")),
      tabItem(tabName = "summary_statistics", mod_summary_statistics_ui("summary_statistics")),
      tabItem(tabName = "risk_factors", mod_risk_factors_ui("risk_factors")),
      tabItem(tabName = "biosecurity_evaluation", mod_biosecurity_evaluation_ui("biosecurity_evaluation"))
    )
  ),
  controlbar = dashboardControlbar(),
  title = "DashboardPage"
)