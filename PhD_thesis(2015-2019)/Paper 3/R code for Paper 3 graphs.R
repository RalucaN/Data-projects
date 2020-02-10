## Graphs for Paper 3


#Loading packages
library(readr)
library(readxl)
library(ggplot2)
library(arm)
library(dplyr)
library(ggpubr)

#Data loading
Paper_3_dataset<- read_excel("Paper_3_dataset.xlsx")

#1.Standardizing all the variable
Paper_3_dataset$polity.z<-rescale(Paper_3_dataset$polity2)
Paper_3_dataset$v2x_libdem.z<-rescale(Paper_3_dataset$v2x_libdem)
Paper_3_dataset$inverse_cl.z<-rescale(Paper_3_dataset$inverse_cl)
Paper_3_dataset$inverse_pr.z<-rescale(Paper_3_dataset$inverse_pr)
Paper_3_dataset$FH_press_Total_Score_inv.z<-rescale(Paper_3_dataset$FH_press_Total_Score_inv)
Paper_3_dataset$China_exports_GDP.z<-rescale(Paper_3_dataset$China_exports_GDP)
Paper_3_dataset$China_imports_GDP.z<-rescale(Paper_3_dataset$China_imports_GDP)
Paper_3_dataset$Year<-as.numeric(Paper_3_dataset$Year)

#1. Variation plot of DD
Paper_3_dataset$democracy<-as.factor(Paper_3_dataset$democracy)

ggplot(na.omit(Paper_3_dataset[,c("Year", "Country_name", "democracy")]), aes(Year, Country_name)) +
  geom_point(aes(color = democracy))+ xlab("Year") + 
  ylab("Country")
ggpubr::color_palette("jco")+
  ggpubr::theme_pubclean()

#2. Variation plot of FOTP status
Paper_3_dataset$FH_press_Status <- factor(Paper_3_dataset$FH_press_Status, levels=c("NF","PF","F"))
ggplot(na.omit(Paper_3_dataset[,c("Year", "Country_name", "FH_press_Status")]), aes(Year, Country_name)) +
  geom_point(aes(color = FH_press_Status))+ xlab("Year") + scale_colour_discrete(name = "FOTP status")+
  ylab("Country") 
ggpubr::color_palette("jco")+
  ggpubr::theme_pubclean()


## Aggregating the data by Country
robustness_graph<-Paper_3_dataset[, c("Country_code","Country_name","China_exports_GDP", "China_imports_GDP", 
                                     "polity2", "inverse_pr", "inverse_cl")]
robustness_graph$Country_name<-as.factor(robustness_graph$Country_name)
robustness_graph$Country_code<-as.character(robustness_graph$Country_code)

robustness_graph<- robustness_graph %>%
  group_by(Country_name) %>%
  summarise(Country_code=unique(Country_code), China_exports_GDP=mean(China_exports_GDP, na.rm = TRUE), 
            China_imports_GDP=mean(China_imports_GDP, na.rm = TRUE), polity2=mean(polity2, na.rm = TRUE), 
            inverse_cl=mean(inverse_cl, na.rm = TRUE), 
            inverse_pr=mean(inverse_pr, na.rm = TRUE))

attach(robustness_graph)
robustness_graph$polity_status[polity2 >= 5.5] <- "Democracy"
robustness_graph$polity_status[polity2 > -5.5 & polity2 < 5.5] <- "Anocracy"
robustness_graph$polity_status[polity2 <= -5.5] <- "Autocracy"

robustness_graph$polity_status <- factor(robustness_graph$polity_status, 
                                         levels=c("Autocracy","Anocracy","Democracy"))

robustness_graph$mean_cl_pr<-(robustness_graph$inverse_cl+robustness_graph$inverse_pr)/2

attach(robustness_graph)
robustness_graph$mean_cl_pr_status[mean_cl_pr >= 5.5] <- "Free"
robustness_graph$mean_cl_pr_status[mean_cl_pr > 2.5 & inverse_cl < 5.5] <- "Partially free"
robustness_graph$mean_cl_pr_status[mean_cl_pr <= 2.5] <- "Not free"

robustness_graph$mean_cl_pr_status <- factor(robustness_graph$mean_cl_pr_status, 
                                           levels=c("Not free","Partially free","Free"))

#3. Plot of exports by Polity

ggplot(robustness_graph, aes(y=log(robustness_graph$China_exports_GDP), x=robustness_graph$polity2, 
                             color=polity_status))+
  geom_text(aes(label=robustness_graph$Country_code), size=3)+xlab("Polity 2 average score")+
  ylab("Log of Chinese exports as % of GDP") + 
    scale_colour_discrete(name = "Type of Polity")



#4. Plot of exports by mean of cl and pr


ggplot(robustness_graph, aes(y=log(robustness_graph$China_exports_GDP), x=robustness_graph$mean_cl_pr, 
                           color=mean_cl_pr_status))+
  geom_text(aes(label=robustness_graph$Country_code), size=3)+xlab("FH inverted CL and PR average score")+
  ylab("Log of Chinese exports as % of GDP") + 
  scale_colour_discrete(name = "Type of freedom")

#5.Variation plot of FH PR and CL
ggplot(chapter1_dataset, aes(x=Year)) + facet_wrap (~ Country_name) + 
  geom_line(aes(y=inverse_cl.z, group=Country_name, colour="FH CL"))+
  geom_line(aes(y=inverse_pr.z, group=Country_name, colour="FH PR")) +
  scale_colour_discrete(name = "Standardized Variables") + xlab("Year") + 
  ylab("Standardized deviations from mean") + ggtitle("Variation in Freedom House's PR and CL") + 
  theme(axis.text.x =element_text(angle = 75, hjust = 1))
