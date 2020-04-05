library(readr)
library(caret)
library(randomForest)
library(FSelector)

Data_processed <- read_csv("Women_in_Data_Science_programme_(Feb 2020-)/Data_processed.csv")


set.seed(101)

#splitting the sample
Data_processed$Result_Type <- factor(Data_processed$Result_Type, ordered = FALSE )
Data_processed$Result_Type <- relevel(Data_processed$Result_Type, ref = "PASS")
sample_size = floor(0.8*nrow(Data_processed))
train_ind = sample(seq_len(nrow(Data_processed)),size = sample_size)
train =Data_processed[train_ind,]
test=Data_processed[-train_ind,]
train$Zone1_Area <- factor(train$Zone1_Area)
train$Zone3_Area <- factor(train$Zone3_Area)
train$SKU <- factor(train$SKU)
train$Result_Type <- factor(train$Result_Type)

#rpart
rPartMod <- train(Result_Type ~ ., data=na.omit(train), method="rpart")
rpartImp <- varImp(rPartMod)
print(rpartImp)

#random forest features' importance
fit_rf = randomForest(Result_Type~., data=na.omit(train))
importance(fit_rf)
varImp(fit_rf)
varImpPlot(fit_rf)

att.scores <- random.forest.importance(Result_Type~., data=na.omit(train))
cutoff.biggest.diff(att.scores)

#chi-squared features selection
weights <- chi.squared(Result_Type~., data=na.omit(train)) 
print(weights)
subset <- cutoff.k(weights, 25) 
f <- as.simple.formula(subset, "Result_Type") 
print(f)

#information gain
weights_inf <- information.gain(Result_Type~., data=na.omit(train))
print(weights_inf)
subset_inf <- cutoff.k(weights_inf, 24) 
f_inf <- as.simple.formula(subset_inf, "Result_Type") 
print(f_inf)

