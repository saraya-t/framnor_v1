
browse_mode <- "FALSE"
# browse_mode <- "TRUE"
local_mode  <- "FALSE"
# local_mode  <- "TRUE"

local_data_file <- "input/questionnaire_survey_sample_20210823.xlsx"
googlesheet_url <- "https://docs.google.com/spreadsheets/d/1FCCYlDTuPIaFXB-FRlgTyzAfAA1ti-cL-Ajelb9SgWw"

Sys.setenv("BROWSE"               = browse_mode)
Sys.setenv("LOCAL_DATA"           = local_mode)
Sys.setenv("LOCAL_GIS_FISKERIDIR" = TRUE)

if (local_mode == "FALSE") {
  googlesheets4::gs4_auth(cache = ".secrets", email = Sys.getenv("GOOGLE_EMAIL"))
}


library(magrittr)
library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(shinydashboardPlus)
library(sf)

source("R/read_form.R", local = TRUE)
source("R/helpers.R", local = TRUE)
source("R/calculate_stats.R", local = TRUE)
# source("R/growout_test.R", local = TRUE)
# source("R/onland_hatchery_test.R", local = TRUE)
source("R/biosecurity_evaluation.R", local = TRUE)
source("R/summary_statistics.R", local = TRUE)
source("R/lokaliter.R", local = TRUE)

source("R/mod_home.R", local = TRUE)
source("R/mod_what_is_biosecurity.R", local = TRUE)
source("R/mod_summary_statistics.R", local = TRUE)
source("R/mod_risk_factors.R", local = TRUE)
source("R/mod_biosecurity_evaluation.R", local = TRUE)
source("R/mod_biosecurity_evaluation_norway.R", local = TRUE)
source("R/mod_biosecurity_evaluation_user.R", local = TRUE)

# # Source tibbles
# source("input/onland_hatchery_scoring_tables.R", local = TRUE)
# source("input/growout_scoring_tables.R", local = TRUE)

lfl_provider_ <- "OpenStreetMap.Mapnik"

nw_zones <- sf::read_sf(dsn = here::here("input/nw_zones/"),
                        layer = "Produksjon_omraader")

# NOTE Tema 2 misses a colon ':' in the Google form
question_sections_all <- tibble::tribble(
  ~section, ~section_title_nw,
  "1",  "Tema 1: Generell informasjon",
  "2",  "Tema 2: Generelle opplysninger om lokaliteten",
  "3",  "Tema 3: Vannkilder og vannbehandling (hopp over dette temaet hvis lokaliteten er i sjø)",
  "4",  "Tema 4: Inntak av rogn på lokaliteten (hopp over dette temaet hvis det ikke er inntak av rogn på lokaliteten)",
  "5",  "Tema 5: Inntak av levende fisk på lokaliteten ",
  "6",  "Tema 6: Vaksiner og vaksineringsprosedyrer",
  "7",  "Tema 7: Fôr og fôringsrutiner",
  "8",  "Tema 8: Driftsrutiner",
  "9",  "Tema 9: Utstyr & kjøretøy ",
  "10", "Tema 10: Vektorer (dyr og dyreliv)",
  "11", "Tema 11: Vektorer (personer på lokaliteten-personell)",
  "12", "Tema 12: Vektorer (personer-gjester)",
  "13", "Tema 13: Bruk av dykkere ",
  "14", "Tema 14: Avfallshåndtering ",
  "15", "Tema 15: Slakting",
  "16", "Tema 16: Overvåkning av fiskehelsen i anlegget",
  "17", "Tema 17: Diagnoser og rapportering",
  "18", "Tema 18: Biosikkerhetsplan og registrering av data")


question_info_ <- tibble::tribble(
  ~question_lvl2_id, ~question_type, ~question_row_n, ~question_col_n, ~other,
  "1.1",   "text",           "1",   "0",    FALSE,
  "1.2",   "text",           "1",   "0",    FALSE,
  "1.3",   "text",           "1",   "0",    FALSE,
  "1.4",   "date",           "1",   "0",    FALSE,
  "1.5",   "checkbox",       "7",   "0",    FALSE,
  "1.6",   "ls_1_10",        "10",  "0",    FALSE,
  "2.1",   "text",           "1",   "0",    FALSE,
  "2.2",   "ls_1_10",        "10",  "0",    FALSE,
  "2.3",   "mc",             "3",   "0",    TRUE,
  "2.4",   "mc",             "4",   "0",    TRUE,
  "2.5",   "mc_grid_yn",     "2",   "2",    FALSE,
  "2.6",   "mc",             "4",   "0",    TRUE,
  "2.7",   "mc",             "4",   "0",    FALSE,
  "2.8",   "mc",             "4",   "0",    TRUE,
  "2.9",   "mc",             "3",   "0",    FALSE,
  "2.10",  "mc_grid",        "4",   "4",    FALSE,
  "2.11",  "mc_grid",        "3",   "4",    FALSE,
  "3.1",   "mc_grid_yn",     "3",   "2",    FALSE,
  "3.2",   "mc_grid_yn",     "6",   "2",    FALSE,
  "3.3",   "mc_yn",          "2",   "0",    FALSE,
  "3.4",   "text",           "1",   "0",    FALSE,
  "3.5",   "mc_yn",          "2",   "0",    FALSE,
  "3.6",   "text",           "1",   "0",    FALSE,
  "4.1",   "mc_yn",          "2",   "0",    FALSE,
  "4.2",   "mc_grid",        "2",   "3",    FALSE,
  "4.3",   "mc_grid_yn",     "5",   "2",    FALSE,
  "4.4",   "mc_grid_yn",     "5",   "2",    FALSE,
  "4.5",   "mc_yn",          "2",   "0",    FALSE,
  "4.6",   "mc_yn",          "2",   "0",    FALSE,
  "5.1",   "mc_yn",          "2",   "0",    FALSE,
  "5.2",   "mc_grid",        "2",   "3",    FALSE,
  "5.3",   "mc_grid",        "2",   "4",    FALSE,
  "5.4",   "mc_grid_yn",     "5",   "2",    FALSE,
  "5.5",   "mc_grid_yn",     "5",   "2",    FALSE,
  "5.6",   "mc_yn",          "2",   "0",    FALSE,
  "5.7",   "mc_yn",          "2",   "0",    FALSE,
  "5.8",   "mc_yn",          "2",   "0",    FALSE,
  "5.9",   "mc_yn",          "2",   "0",    FALSE,
  "5.10",  "mc_yn",          "2",   "0",    FALSE,
  "6.1",   "mc_grid",        "10",  "4",    FALSE,
  "6.2",   "mc_grid_yn",     "10",  "2",    FALSE,
  "6.3",   "mc",             "3",   "0",    FALSE,
  "6.4",   "mc",             "3",   "0",    FALSE,
  "7.1",   "mc",             "5",   "0",    FALSE,
  "7.2",   "checkbox",       "2",   "0",    TRUE, 
  "7.3",   "checkbox",       "3",   "0",    TRUE, 
  "7.4",   "mc",             "3",   "0",    FALSE, 
  "7.5",   "mc",             "6",   "0",    FALSE, 
  "7.6",   "mc_yn",          "2",   "0",    FALSE, 
  "7.7",   "mc",             "5",   "0",    FALSE, 
  "8.1",   "mc_yn",          "2",   "0",    FALSE, 
  "8.2",   "mc_yn",          "2",   "0",    FALSE, 
  "8.3",   "mc_yn",          "3",   "0",    FALSE, 
  "8.4",   "mc_yn",          "2",   "0",    FALSE, 
  "8.5",   "mc_yn",          "2",   "0",    FALSE, 
  "8.6",   "mc_grid",        "7",   "3",    FALSE, 
  "8.7",   "mc",             "2",   "0",    FALSE, 
  "8.8",   "mc_yn",          "3",   "0",    FALSE, 
  "8.9",   "mc",             "2",   "0",    FALSE, 
  "8.10",  "mc_grid",        "6",   "6",    FALSE, 
  "9.1",   "mc_grid",        "10",  "4",    FALSE, 
  "9.2",   "mc_yn",          "3",   "0",    FALSE, 
  "9.3",   "mc_yn",          "2",   "0",    FALSE, 
  "9.4",   "mc_yn",          "3",   "0",    FALSE, 
  "9.5",   "mc_grid",        "6",   "3",    FALSE, 
  "9.6",   "mc_yn",          "2",   "0",    FALSE, 
  "9.7",   "mc_yn",          "2",   "0",    FALSE, 
  "9.8",   "mc_yn",          "2",   "0",    FALSE, 
  "9.9",   "mc_grid",        "4",   "4",    FALSE, 
  "9.10",  "mc_grid",        "4",   "4",    FALSE, 
  "9.11",  "mc_grid_yn",     "5",   "2",    FALSE, 
  "9.12",  "mc_yn",          "3",   "0",    FALSE, 
  "9.13",  "mc_yn",          "3",   "0",    FALSE, 
  "10.1",  "mc_yn",          "2",   "0",    FALSE, 
  "10.2",  "mc_yn",          "2",   "0",    FALSE, 
  "10.3",  "mc_grid_yn",     "4",   "2",    FALSE, 
  "11.1",  "mc_yn",          "2",   "0",    FALSE, 
  "11.2",  "mc_yn",          "2",   "0",    FALSE, 
  "11.3",  "mc_grid_yn",     "5",   "2",    FALSE, 
  "11.4",  "mc_grid_yn",     "4",   "2",    FALSE, 
  "11.5",  "mc_grid_yn",     "3",   "2",    FALSE, 
  "11.6",  "mc",             "5",   "0",    FALSE, 
  "11.7",  "mc",             "5",   "0",    FALSE, 
  "11.8",  "text",           "1",   "0",    FALSE, 
  "11.9",  "mc_yn",          "2",   "0",    FALSE, 
  "12.1",  "mc_yn",          "3",   "0",    FALSE, 
  "12.2",  "mc_yn",          "3",   "0",    FALSE, 
  "12.3",  "mc_yn",          "3",   "0",    FALSE, 
  "12.4",  "mc_yn",          "3",   "0",    FALSE, 
  "12.5",  "mc_yn",          "3",   "0",    FALSE, 
  "12.6",  "mc_yn",          "3",   "0",    FALSE, 
  "12.7",  "mc_yn",          "3",   "0",    FALSE, 
  "12.8",  "mc_yn",          "3",   "0",    FALSE, 
  "13.1",  "mc",             "5",   "0",    FALSE, 
  "13.2",  "mc_yn",          "3",   "0",    FALSE, 
  "13.3",  "mc_yn",          "3",   "0",    FALSE, 
  "13.4",  "mc_yn",          "3",   "0",    FALSE, 
  "13.5",  "mc_yn",          "3",   "0",    FALSE, 
  "14.1",  "mc_yn",          "2",   "0",    FALSE, 
  "14.2",  "mc_yn",          "2",   "0",    FALSE, 
  "14.3",  "mc_yn",          "2",   "0",    FALSE, 
  "14.4",  "mc_yn",          "2",   "0",    FALSE, 
  "14.5",  "mc_yn",          "2",   "0",    FALSE, 
  "14.6",  "mc",             "4",   "0",    FALSE, 
  "14.7",  "mc",             "4",   "0",    FALSE, 
  "15.1",  "mc_yn",          "2",   "0",    FALSE, 
  "15.2",  "mc_yn",          "3",   "0",    FALSE, 
  "15.3",  "mc_yn",          "3",   "0",    FALSE, 
  "15.4",  "mc_yn",          "3",   "0",    FALSE, 
  "15.5",  "mc_yn",          "3",   "0",    FALSE, 
  "15.6",  "mc_grid_yn",     "3",   "3",    FALSE, 
  "15.7",  "mc_yn",          "3",   "0",    FALSE, 
  "15.8",  "mc_yn",          "3",   "0",    FALSE, 
  "16.1",  "mc_grid",        "5",   "6",    FALSE, 
  "16.2",  "mc",             "2",   "0",    TRUE, 
  "16.3",  "mc",             "4",   "0",    FALSE, 
  "16.4",  "mc_grid_yn",     "5",   "2",    FALSE, 
  "16.5",  "mc_yn",          "2",   "0",    FALSE, 
  "16.6",  "mc_yn",          "2",   "0",    FALSE, 
  "16.7",  "mc_yn",          "2",   "0",    FALSE, 
  "16.8",  "mc_grid_yn",     "3",   "2",    FALSE, 
  "16.9",  "mc_yn",          "2",   "0",    FALSE, 
  "16.10", "mc_yn",          "2",   "0",    FALSE, 
  "16.11", "mc_yn",          "2",   "0",    FALSE, 
  "17.1",  "mc",             "7",   "0",    FALSE, 
  "17.2",  "mc_yn",          "2",   "0",    FALSE, 
  "17.3",  "mc_grid_yn",     "6",   "2",    FALSE, 
  "17.4",  "mc_grid_yn",     "5",   "2",    FALSE, 
  "17.5",  "mc_grid_yn",     "6",   "2",    FALSE, 
  "17.6",  "mc_grid_yn",     "3",   "3",    FALSE, 
  "17.7",  "mc",             "3",   "0",    FALSE, 
  "17.8",  "checkbox",       "4",   "0",    FALSE, 
  "17.9",  "mc_yn",          "2",   "0",    FALSE, 
  "17.10", "mc_yn",          "2",   "0",    FALSE, 
  "17.11", "mc_yn",          "2",   "0",    FALSE, 
  "17.12", "mc_grid_yn",     "5",   "2",    FALSE, 
  "18.1",  "mc_yn",          "2",   "0",    FALSE, 
  "18.2",  "mc",             "4",   "0",    FALSE, 
  "18.3",  "mc_yn",          "2",   "0",    FALSE, 
  "18.4",  "mc",             "4",   "0",    FALSE, 
  "18.5",  "mc_grid_yn",     "5",   "2",    FALSE, 
  "18.6",  "text",           "1",   "0",    FALSE) %>% 
  dplyr::left_join(
    tibble::tribble(
      ~question_type, ~viz_type,
      "text",       "bar",
      "date",       "date_list",
      "ls_1_10",    "bar",
      "checkbox",   "bar_h",
      "mc",         "pie",
      "mc_yn",      "pie",
      "mc_grid_yn", "x_bar_y_col",
      "mc_grid",    "x_bar_y_col"),
    by = "question_type")



customTheme <- shinyDashboardThemeDIY(
  
  ### general
  appFontFamily = "Arial"
  ,appFontColor = "rgb(0,0,0)"
  ,primaryFontColor = "rgb(0,0,0)"
  ,infoFontColor = "rgb(0,0,0)"
  ,successFontColor = "rgb(0,0,0)"
  ,warningFontColor = "rgb(0,0,0)"
  ,dangerFontColor = "rgb(0,0,0)"
  ,bodyBackColor = "rgb(248,248,248)"
  
  ### header
  ,logoBackColor = "rgb(23,103,124)"
  
  ,headerButtonBackColor = "rgb(238,238,238)"
  ,headerButtonIconColor = "rgb(75,75,75)"
  ,headerButtonBackColorHover = "rgb(210,210,210)"
  ,headerButtonIconColorHover = "rgb(0,0,0)"
  
  ,headerBackColor = "rgb(238,238,238)"
  ,headerBoxShadowColor = "#aaaaaa"
  ,headerBoxShadowSize = "2px 2px 2px"
  
  ### sidebar
  ,sidebarBackColor = "#9DC3E6"
  # ,sidebarBackColor = cssGradientThreeColors(
  #   direction = "down"
  #   ,colorStart = "rgb(20,97,117)"
  #   ,colorMiddle = "rgb(56,161,187)"
  #   ,colorEnd = "rgb(3,22,56)"
  #   ,colorStartPos = 0
  #   ,colorMiddlePos = 50
  #   ,colorEndPos = 100
  # )
  ,sidebarPadding = 0

  ,sidebarMenuBackColor = "transparent"
  ,sidebarMenuPadding = 0
  ,sidebarMenuBorderRadius = 0

  ,sidebarShadowRadius = "3px 5px 5px"
  ,sidebarShadowColor = "#aaaaaa"

  ,sidebarUserTextColor = "rgb(255,255,255)"

  ,sidebarSearchBackColor = "rgb(55,72,80)"
  ,sidebarSearchIconColor = "rgb(153,153,153)"
  ,sidebarSearchBorderColor = "rgb(55,72,80)"

  ,sidebarTabTextColor = "rgb(255,255,255)"
  ,sidebarTabTextSize = 13
  ,sidebarTabBorderStyle = "none none solid none"
  ,sidebarTabBorderColor = "rgb(35,106,135)"
  ,sidebarTabBorderWidth = 1

  ,sidebarTabBackColorSelected = cssGradientThreeColors(
    direction = "right"
    ,colorStart = "rgba(44,222,235,1)"
    ,colorMiddle = "rgba(44,222,235,1)"
    ,colorEnd = "rgba(0,255,213,1)"
    ,colorStartPos = 0
    ,colorMiddlePos = 30
    ,colorEndPos = 100
  )
  ,sidebarTabTextColorSelected = "rgb(0,0,0)"
  ,sidebarTabRadiusSelected = "0px 20px 20px 0px"

  ,sidebarTabBackColorHover = cssGradientThreeColors(
    direction = "right"
    ,colorStart = "rgba(44,222,235,1)"
    ,colorMiddle = "rgba(44,222,235,1)"
    ,colorEnd = "rgba(0,255,213,1)"
    ,colorStartPos = 0
    ,colorMiddlePos = 30
    ,colorEndPos = 100
  )
  ,sidebarTabTextColorHover = "rgb(50,50,50)"
  ,sidebarTabBorderStyleHover = "none none solid none"
  ,sidebarTabBorderColorHover = "rgb(75,126,151)"
  ,sidebarTabBorderWidthHover = 1
  ,sidebarTabRadiusHover = "0px 20px 20px 0px"

  ### boxes
  ,boxBackColor = "rgb(255,255,255)"
  ,boxBorderRadius = 5
  ,boxShadowSize = "0px 1px 1px"
  ,boxShadowColor = "rgba(0,0,0,.1)"
  ,boxTitleSize = 16
  ,boxDefaultColor = "rgb(210,214,220)"
  ,boxPrimaryColor = "rgba(44,222,235,1)"
  ,boxInfoColor = "rgb(210,214,220)"
  ,boxSuccessColor = "rgba(0,255,213,1)"
  ,boxWarningColor = "rgb(244,156,104)"
  ,boxDangerColor = "rgb(255,88,55)"

  ,tabBoxTabColor = "rgb(255,255,255)"
  ,tabBoxTabTextSize = 14
  ,tabBoxTabTextColor = "rgb(0,0,0)"
  ,tabBoxTabTextColorSelected = "rgb(0,0,0)"
  ,tabBoxBackColor = "rgb(255,255,255)"
  ,tabBoxHighlightColor = "rgba(44,222,235,1)"
  ,tabBoxBorderRadius = 5

  ### inputs
  ,buttonBackColor = "rgb(245,245,245)"
  ,buttonTextColor = "rgb(0,0,0)"
  ,buttonBorderColor = "rgb(200,200,200)"
  ,buttonBorderRadius = 5

  ,buttonBackColorHover = "rgb(235,235,235)"
  ,buttonTextColorHover = "rgb(100,100,100)"
  ,buttonBorderColorHover = "rgb(200,200,200)"

  ,textboxBackColor = "rgb(255,255,255)"
  ,textboxBorderColor = "rgb(200,200,200)"
  ,textboxBorderRadius = 5
  ,textboxBackColorSelect = "rgb(245,245,245)"
  ,textboxBorderColorSelect = "rgb(200,200,200)"

  ### tables
  ,tableBackColor = "rgb(255,255,255)"
  ,tableBorderColor = "rgb(240,240,240)"
  ,tableBorderTopSize = 1
  ,tableBorderRowSize = 1
  
)
