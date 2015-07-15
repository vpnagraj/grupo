library(shiny)
instnames <- read.csv("institutions.csv", stringsAsFactors=FALSE)

shinyServer(function(input, output) {
        
        output$help <- renderText({
        
        txt <- "<h3>GET STARTED</h3><ol><li>Select a range of publication dates</li><li>Select the first institution</li><li>Select the second institution for comparison</li></ol>"
                
        if (input$institution1=="NOT SELECTED")
        return(txt)
                
        if (input$institution2=="NOT SELECTED")
        return(txt)
        })
        
        output$barplot <- renderPlot({ 
                
        if (input$institution1=="NOT SELECTED")
        return(NULL)
        
        if (input$institution2=="NOT SELECTED")
        return(NULL)
                
        library(rentrez)
        
        if (grepl("-", input$institution1)==TRUE) {                
                split_name <- strsplit(input$institution1, split="-")
                search_term <- paste(split_name[[1]][1], '[Affiliation]', sep='')
                search_term <- paste(search_term, ' AND ', split_name[[1]][2], '[Affiliation]',sep='')
                search_term <- paste(search_term, input$dates[1], sep= ' AND ')
                search_term <- paste(search_term, input$dates[2], sep='[PDAT] : ')
                search_term <- paste(search_term, '[PDAT]', sep='')
                search_term <- gsub("-","/",search_term)
        } else {
                search_term <- paste(input$institution1, '[Affiliation]', sep='')
                search_term <- paste(search_term, input$dates[1], sep= ' AND ')
                search_term <- paste(search_term, input$dates[2], sep='[PDAT] : ')
                search_term <- paste(search_term, '[PDAT]', sep='')
                search_term <- gsub("-","/",search_term)
        }
             
        affiliation_search <- entrez_search("pubmed", search_term, retmax=999999)
        total_articles <- as.numeric(affiliation_search$count)
        
        inst <- input$institution1
        df <- data.frame(inst,total_articles)
        df$inst <- as.character(df$inst)


        if (grepl("-", input$institution2)==TRUE) {       
                split_name <- strsplit(input$institution2, split="-")
                search_term2 <- paste(split_name[[1]][1], '[Affiliation]', sep='')
                search_term2 <- paste(search_term2, ' AND ', split_name[[1]][2], '[Affiliation]',sep='')
                search_term2 <- paste(search_term2, input$dates[1], sep= ' AND ')
                search_term2 <- paste(search_term2, input$dates[2], sep='[PDAT] : ')
                search_term2 <- paste(search_term2, '[PDAT]', sep='')
                search_term2 <- gsub("-","/",search_term2)
        
        } else {
                search_term2 <- paste(input$institution2, '[Affiliation]', sep='')
                search_term2 <- paste(search_term2, input$dates[1], sep= ' AND ')
                search_term2 <- paste(search_term2, input$dates[2], sep='[PDAT] : ')
                search_term2 <- paste(search_term2, '[PDAT]', sep='')
                search_term2 <- gsub("-","/",search_term2)
}
        
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
        
        library(ggplot2)
        library(ggthemes)

g <- ggplot(df, aes(Institution,Total.Articles, fill=Institution)) + geom_bar(stat = "identity") + ggtitle(plot_title) + ylab("Total Articles Indexed In Pubmed") + theme_few()
        g


        })

output$links <- renderText ({ 

        if (input$institution1=="NOT SELECTED")
                return(NULL)
        
        if (input$institution2=="NOT SELECTED")
                return(NULL)
        
        library(rentrez)
                
        if (grepl("-", input$institution1)==TRUE) {                
                split_name <- strsplit(input$institution1, split="-")
                search_term <- paste(split_name[[1]][1], '[Affiliation]', sep='')
                search_term <- paste(search_term, ' AND ', split_name[[1]][2], '[Affiliation]',sep='')
                search_term <- paste(search_term, input$dates[1], sep= ' AND ')
                search_term <- paste(search_term, input$dates[2], sep='[PDAT] : ')
                search_term <- paste(search_term, '[PDAT]', sep='')
                search_term <- gsub("-","/",search_term)
        } else {
                search_term <- paste(input$institution1, '[Affiliation]', sep='')
                search_term <- paste(search_term, input$dates[1], sep= ' AND ')
                search_term <- paste(search_term, input$dates[2], sep='[PDAT] : ')
                search_term <- paste(search_term, '[PDAT]', sep='')
                search_term <- gsub("-","/",search_term)
}
                
                affiliation_search <- entrez_search("pubmed", search_term, retmax=999999)
                total_articles <- as.numeric(affiliation_search$count)
                inst <- input$institution1

        if (grepl("-", input$institution2)==TRUE) {        
                split_name <- strsplit(input$institution2, split="-")
                search_term2 <- paste(split_name[[1]][1], '[Affiliation]', sep='')
                search_term2 <- paste(search_term2, ' AND ', split_name[[1]][2], '[Affiliation]',sep='')
                search_term2 <- paste(search_term2, input$dates[1], sep= ' AND ')
                search_term2 <- paste(search_term2, input$dates[2], sep='[PDAT] : ')
                search_term2 <- paste(search_term2, '[PDAT]', sep='')
                search_term2 <- gsub("-","/",search_term2)

        } else {
                search_term2 <- paste(input$institution2, '[Affiliation]', sep='')
                search_term2 <- paste(search_term2, input$dates[1], sep= ' AND ')
                search_term2 <- paste(search_term2, input$dates[2], sep='[PDAT] : ')
                search_term2 <- paste(search_term2, '[PDAT]', sep='')
                search_term2 <- gsub("-","/",search_term2)
}
                inst2 <- input$institution2
                
                artcl_link1 <- paste("<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=", search_term, "\" target='_blank'\">", inst, "</a>",sep="" )
                artcl_link2 <- paste("<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=", search_term2, "\" target='_blank'\">", inst2, "</a>",sep="" )
        artcl_links <- paste("View Pubmed Results:",artcl_link1, "/", artcl_link2, sep=" ")
        artcl_links
        
        })

        output$collaborations <- renderText ({ 
        
        if (input$institution1=="NOT SELECTED")
        return(NULL)
        
        if (input$institution2=="NOT SELECTED")
        return(NULL)
        
        library(rentrez)
        
        if (grepl("-", input$institution1)==TRUE) {       
                split_name <- strsplit(input$institution1, split="-")
                search_term <- paste(split_name[[1]][1], '[Affiliation]', sep='')
                search_term <- paste(search_term, ' AND ', split_name[[1]][2], '[Affiliation]',sep='')
                search_term <- paste(search_term, input$dates[1], sep= ' AND ')
                search_term <- paste(search_term, input$dates[2], sep='[PDAT] : ')
                search_term <- paste(search_term, '[PDAT]', sep='')
                search_term <- gsub("-","/",search_term)
                affiliation_search <- entrez_search("pubmed", search_term, retmax=999999)
                total_articles <- as.numeric(affiliation_search$count)
        
        } else {
                search_term <- paste(input$institution1, '[Affiliation]', sep='')
                search_term <- paste(search_term, input$dates[1], sep= ' AND ')
                search_term <- paste(search_term, input$dates[2], sep='[PDAT] : ')
                search_term <- paste(search_term, '[PDAT]', sep='')
                search_term <- gsub("-","/",search_term)
        }
        
        inst <- input$institution1
        
        if (grepl("-", input$institution2)==TRUE) {        
                split_name <- strsplit(input$institution2, split="-")
                search_term2 <- paste(split_name[[1]][1], '[Affiliation]', sep='')
                search_term2 <- paste(search_term2, ' AND ', split_name[[1]][2], '[Affiliation]',sep='')
                search_term2 <- paste(search_term2, input$dates[1], sep= ' AND ')
                search_term2 <- paste(search_term2, input$dates[2], sep='[PDAT] : ')
                search_term2 <- paste(search_term2, '[PDAT]', sep='')
                search_term2 <- gsub("-","/",search_term2)

        } else {
                search_term2 <- paste(input$institution2, '[Affiliation]', sep='')
                search_term2 <- paste(search_term2, input$dates[1], sep= ' AND ')
                search_term2 <- paste(search_term2, input$dates[2], sep='[PDAT] : ')
                search_term2 <- paste(search_term2, '[PDAT]', sep='')
                search_term2 <- gsub("-","/",search_term2)
        }

        inst2 <- input$institution2
        
        search_term3 <- paste(search_term, "AND", search_term2, sep=" ")

        collaboration_link <- paste("View Pubmed Results:","<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/?term=", search_term3,  "\" target='_blank'\">", "Collaborations Between These Institutions", "</a>*",sep=" " )
        collaboration_link <- paste(collaboration_link, "</br>*<sub>Collabarations are identified as publications that share authorship between institutions. According to the <a href='http://www.nlm.nih.gov/bsd/mms/medlineelements.html#ad'>NLM documentation for field descriptions</a>, institutional affiliation for all authors was not officially added until 2014.</sub></br>" ,sep='')

        collaboration_link
})

        output$summary <- renderText({
        
        txt <- "<p>GRUPO (Gauging Research University Publication Output) is a dashboard for comparing publication activity between institutions over a specified period of time. The application builds a <a href='http://www.ncbi.nlm.nih.gov/pubmed'> Pubmed</a> search based on the date, first institution and second institution inputs.</p><p>Below is a list of all institutions that are searchable:</p>"
        txt
})
})