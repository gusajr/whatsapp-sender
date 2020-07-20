library('RSelenium')
library('tidyverse')

setwd("/home/gusajr/Documents/webScrapping/whatsapp-sender")
driver <- RSelenium::rsDriver(browser=c("firefox"))
driverDr <- driver[["client"]]

driverDr$navigate("https://web.whatsapp.com/")

#just waiting while scanning the QR-code and open the web app.
Sys.sleep(60) #------------->Be sure to have the QR scanner close.

#each number should has the following format: 00[country-code][mobile-number]. For example: +52 0000 0000
missed_numbers <- list()

#load phone numbers from file.
#this file is simple csv file contains just one field. This field is just a phone number with previous format.
csv_file <- read.csv("/home/gusajr/Documents/webScrapping/source-numbers.csv")
msg_to_send <- "Hello there..."

tryCatch(
  {
    for(val in 1:length(row(csv_file))){
    driverDr$navigate(paste("https://web.whatsapp.com/send?phone={",csv_file[val,1],"}",sep=""))
    Sys.sleep(10)
    webElement <- driverDr$findElement(using="css selector", value="._2UL8j > div:nth-child(2)")
    webElement$clickElement()
    webElement$sendKeysToElement(list(msg_to_send))
    webElement <- driverDr$findElement(using="css selector", value="._1U1xa")
    webElement$clickElement()
    Sys.sleep(2)
    }
  },error=function(){
    message(paste("Could not send message to:",csv_file[val,1]))
    missed_numbers <- c(missed_numbers, csv_file[val,1])
  },finally=function(){
    message("Finished...")
  }
)

#driverDr$close()
#driver$client$close()