library(shiny)

instnames <- read.csv("institutions.csv", stringsAsFactors=FALSE)
# instnames$City <- paste(instnames$Institution, instnames$City, sep=" ")
# 
# instnames <- as.matrix(instnames)

shinyUI(navbarPage("GRUPO",
        tabPanel("Home",
        tags$h1("GRUPO"),
        tags$h2("Gauging Research University Publication Output"),
        sidebarPanel(
                dateRangeInput(inputId = "dates", label="Enter A Date Range To Search", min="2000-01-01", max=Sys.time()),
        selectInput(inputId = "institution1", label = "First Institution", choices = instnames),
        selectInput(inputId = "institution2", label= "Second Institution", choices=instnames)
),
        mainPanel(
                htmlOutput("help"),
                plotOutput("barplot"),
                htmlOutput("links"),
                htmlOutput("collaborations")
        )
),
        tabPanel("About",
                 tags$h1("GRUPO"),
                 tags$h2("Gauging Research University Publication Output"),
                 htmlOutput("summary"))
)
)