### Graphs for Paper 2 (access to the data used is currently restricted)
 
library("dplyr")
library("ggpubr")
library(MASS)
library(ggplot2)


#1. mean_support (barplot)
ggplot(total_imc,aes(x=mean_support,group=Group_type,fill=Group_type))+
geom_histogram(position="dodge",binwidth=0.25)+theme_bw()

#2. mean_support (density)
ggplot(total_imc, aes(x=mean_support, colour=Group_type)) + geom_density()

#3. median_support (barplot)
ggplot(total_imc,aes(x=as.numeric(median_support),group=Group_type,fill=Group_type))+
  geom_histogram(position="dodge",binwidth=0.25)+theme_bw()

#4. median_support (density)
ggplot(total_imc, aes(x=as.numeric(median_support), colour=Group_type)) + geom_density()




