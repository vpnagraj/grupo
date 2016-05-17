GRUPO
====================

GRUPO (Gauging Research University Publication Output) is a web application built with the R programming language and Shiny framework. The purpose of this tool is to compare the total number of biomedical publications and co-authorships between institutions over a specific range of dates.

GRUPO is available to use via the following URL:

http://apps.bioconnector.virginia.edu/grupo/

GRUPO is also available to use (locally) via the following R code:

```
install.packages("shiny")
install.packages("ggplot2")
install.packages("ggthemes")
install.packages("rentrez")

shiny::runGitHub('grupo', 'vpnagraj')
``` 
