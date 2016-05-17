---
title: 'GRUPO: Gauging Research University Publication Output'
authors:
    - name: VP Nagraj
    orcid: 0000-0003-0060-566X
    affiliation: University of Virginia
date: 17 May 2016
bibliography: paper.bib
---
    
# Summary

[GRUPO (Gauging Research University Publication Output)](http://apps.bioconnector.virginia.edu/grupo/) is a web application built with the R programming language (@R) and Shiny (@shiny) framework. The purpose of this tool is to compare the total number of biomedical publications and co-authorships between institutions over a specific range of dates. The application provides users an interface to select two institutions and a date range. These inputs are dynamically delivered to the PubMed API via the rentrez package (@rentrez). The response is parsed to identify the number of indexed records, as well as unique article identifiers that are subsequently used to infer collaborations based on overlap across institutions. The list of affiliations includes academic organizations that are categorized as "R1" or "Highest Research Activity" (@classifications). The implications for this software extend to bibliometric researchers, academic administrators and beyond. In particular, GRUPO could help frame questions about the scale of research activity or the accuracy of peer institution designations.
    
# References