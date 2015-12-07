library(shiny)
library(rentrez)
library(ggmap)
library(ggplot2)

# source script to load helper functions
source('helpers.R')

# read in geocoded institution data
instnames <- read.csv("institutions.csv", stringsAsFactors=FALSE)

# create map of all institutions to be rendedered on about page
usa_map <- get_map(location = "United States", zoom=3, maptype = "watercolor")

q <-
    ggmap(usa_map) +
    geom_point(aes(x=Longitude, y=Latitude), data=instnames, col="red") +
    theme_nothing()

shinyServer(function(input, output) {
    
        dat <- eventReactive(input$go,{
            
            search_term <- build_query(input$institution1, input$dates[1], input$dates[2])
            
            affiliation_search <- entrez_search("pubmed", search_term, retmax=999999)
            total_articles <- as.numeric(affiliation_search$count)
            
            inst <- input$institution1
            df <- data.frame(inst,total_articles)
            df$inst <- as.character(df$inst)
            
            search_term2 <- build_query(input$institution2, input$dates[1], input$dates[2])
            affiliation_search2 <- entrez_search("pubmed", search_term2, retmax=999999)
            total_articles2 <- as.numeric(affiliation_search2$count)
            
            inst2 <- input$institution2
            
            df[2,] <- c(inst2,total_articles2)
            df$inst <- factor(df$inst)
            df$total_articles <- as.numeric(df$total_articles)
            
            names(df) <- c("Institution", "Total.Articles")
            
            collaboration_count <- paste((length(intersect(affiliation_search$ids,affiliation_search2$ids))), "Collaborations Between These Institutions)", sep=" ")
            
            plot_title <- paste(inst, inst2, sep=" / ")
            plot_title <- paste(plot_title,collaboration_count, sep="\n(")
            
            artcl_link1 <- paste("<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=", search_term, "\">", inst, "</a>",sep="" )
            artcl_link2 <- paste("<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=", search_term2, "\">", inst2, "</a>",sep="" )
            
            artcl_links <- paste("View Pubmed Results:",artcl_link1, "/", artcl_link2, sep=" ")
            
            # build collaboration link string to output underneath plot
            search_term3 <- paste(search_term, "AND", search_term2, sep=" ")
            
            collaboration_link <- paste("View Pubmed Results:","<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=", search_term3,  "\" target='_blank'\">", "Collaborations Between These Institutions", "</a>*",sep=" " )
            
            collaboration_link <- paste(collaboration_link, "</br>*<sub>Collabarations are identified as publications that share authorship between institutions. According to the <a href='http://www.nlm.nih.gov/bsd/mms/medlineelements.html#ad'>NLM documentation for field descriptions</a>, institutional affiliation for all authors was not officially added until 2014.</sub></br>" ,sep='')
            
            listdat <- list(df,
                            plot_title,
                            artcl_links, 
                            collaboration_link)
            listdat
            
        })
        
        output$help <- renderText({
            
            "<h3>To Get Started:</h3>
            <ol>
            <li>Select the range of publication dates</li>
            <li>Select the first institution</li>
            <li>Select the second institution</li>
            <li>Press Go!</li>
            </ol>"

        })

        output$barplot <- renderPlot({ 
                
            library(ggplot2)
            library(ggthemes)
            
            df <- dat()[[1]]
            
            plot_title <- dat()[[2]]
            
            g <- 
                ggplot(df, aes(Institution,Total.Articles, fill=Institution)) + 
                geom_bar(stat = "identity") + 
                ggtitle(plot_title) + 
                ylab("Total Articles Indexed In Pubmed") + 
                theme_few()
            g

        })

output$links <- renderText ({ 
    
        artcl_links <- dat()[[3]]
        artcl_links
        
        })

        output$collaborations <- renderText ({ 
        
            collaboration_link <- dat()[[4]]
            collaboration_link
            
})
# 
        output$summary <- renderText({
         
        txt <- "<p>GRUPO (Gauging Research University Publication Output) is a dashboard for comparing publication activity between institutions over a specified period of time. The application builds a <a href='http://www.ncbi.nlm.nih.gov/pubmed'> Pubmed</a> search based on the date, first institution and second institution inputs.</p><p>Below is a list of all the institutions that GRUPO searches:</p>"
        txt
            
})
        output$institutions <- renderDataTable({
            
                institutions <- as.data.frame(instnames$Institution)
                names(institutions) <- c("Institutions")
                institutions
        }, options = list(paging = FALSE))
        
        output$map <- renderPlot({
            
            q
            
        })
        
        
})