### Graphs for Paper 2

#Loading packages
library(readxl) 
library("dplyr")
library("ggpubr")
library(MASS)
library(ggplot2)

#Data loading
Paper_2_sample_data<-read_excel("Paper_2_sample_data.xlsx")

#Creating mean and median variables of interest
Paper_2_sample_data$mean_support<-(as.numeric(Paper_2_sample_data$Agreement1)+as.numeric(Paper_2_sample_data$Agreement2)+
                           as.numeric(Paper_2_sample_data$Agreement3)+as.numeric(Paper_2_sample_data$Agreement4)+
                           as.numeric(Paper_2_sample_data$Agreement5))/5

Paper_2_sample_data$median_support <- apply(Paper_2_sample_data[,2:6], 1, median)

Paper_2_sample_data$median_support<-as.numeric(Paper_2_sample_data$median_support)



#1. mean_support (barplot)
ggplot(Paper_2_sample_data,aes(x=mean_support,group=Group_type,fill=Group_type))+
geom_histogram(position="dodge",binwidth=0.25)+theme_bw()

#2. mean_support (density)
ggplot(Paper_2_sample_data, aes(x=mean_support, colour=Group_type)) + geom_density()

#3. median_support (barplot)
ggplot(Paper_2_sample_data,aes(x=as.numeric(median_support),group=Group_type,fill=Group_type))+
  geom_histogram(position="dodge",binwidth=0.25)+theme_bw()

#4. median_support (density)
ggplot(Paper_2_sample_datac, aes(x=as.numeric(median_support), colour=Group_type)) + geom_density()




