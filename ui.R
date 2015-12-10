library(shiny)

instnames <- read.csv("institutions.csv", stringsAsFactors=FALSE)

shinyUI(navbarPage("GRUPO", 
                   header=(tags$h1("GRUPO", 
                                   align='center', 
                                   tags$u(tags$h2("Gauging Research University Publication Output", align='center', style="margin-top:10px")))), 
                   footer=tags$div(style='margin:20px;',tags$a(href = "https://www.gnu.org/licenses/gpl.txt", "AVAILABLE UNDER GNU GPL 3.0 LICENSE"), tags$p(icon("copyright"), "2015 VP Nagraj")),
        tabPanel("Home",
        sidebarPanel(
            dateRangeInput(inputId = "dates", 
                               label="Enter A Date Range To Search",                                      start = Sys.time() - 3.154e+7,
                               end = Sys.time(),
                               min="2000-01-01", 
                               max=Sys.time()),
            selectInput(inputId = "institution1", 
                    label = "First Institution", 
                    choices=instnames$Institution, 
                    selected = "Harvard"),
            selectInput(inputId = "institution2", 
                    label= "Second Institution", 
                    choices=instnames$Institution, 
                    selected = "Johns Hopkins"),
            actionButton("go", label="Go!")
),
        mainPanel(
            conditionalPanel(condition = "input.go == 0",
                htmlOutput("help")),
            plotOutput("barplot"),
            htmlOutput("links"),
            htmlOutput("collaborations")
        )
),
        tabPanel("About",
            htmlOutput("summary"),
            splitLayout(
            dataTableOutput("institutions")
#             plotOutput("map")
            )
        )


)
)