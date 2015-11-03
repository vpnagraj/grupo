build_query <- function(institution, startDate, endDate) {
    
    if (grepl("-", institution)==TRUE) {                
        split_name <- strsplit(institution, split="-")
        search_term <- paste(split_name[[1]][1], '[Affiliation]',
                             ' AND ',
                             split_name[[1]][2],
                             '[Affiliation]',
                             ' AND ',
                             startDate,
                             '[PDAT] : ',
                             endDate,
                             '[PDAT]',
                             sep='')
        search_term <- gsub("-","/",search_term)
    } else {
        search_term <- paste(institution, 
                             '[Affiliation]',
                             ' AND ',
                             startDate,
                             '[PDAT] : ',
                             endDate,
                             '[PDAT]',
                             sep='')
        search_term <- gsub("-","/",search_term)
    }
    
    return(search_term)
}