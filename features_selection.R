library(readr)
library(Boruta)
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



boruta_output <- Boruta(Result_Type ~ ., data=na.omit(train), doTrace=0) 
names(boruta_output)

plot(boruta_output, cex.axis=.7, las=2, xlab="", main="Variable Importance")


rPartMod <- train(Result_Type ~ ., data=na.omit(train), method="rpart")
rpartImp <- varImp(rPartMod)
print(rpartImp)

# Features: Zone1_In_Zone3_Out_Dur, Zone2Position, Zone1Position, Block_Num, Block_Position, Sku, 
# Zone3_Humidity_Max, Zone3_Humidity_Avg, Zone3_Humidity_Min, Zone2_Humidity_Max, Zone2_Temp_Max,
# Zone1_Col_Num, Zone2_Col_num, Zone1_Area[Top Left]

train$Zone1Position <- factor(train$Zone1Position)
train$Zone2Position <- factor(train$Zone2Position)
train$Block_Position <- factor(train$Block_Position)
train$Block_Num <- factor(train$Block_Num)
train$Zone2_Col_num <- factor(train$Zone2_Col_num)
train$Zone1_Col_Num <- factor(train$Zone1_Col_Num)

rPartMod2 <- train(Result_Type ~ ., data=na.omit(train), method="rpart")
rpartImp2 <- varImp(rPartMod2)
print(rpartImp2)




fit_rf = randomForest(Result_Type~., data=na.omit(train))
importance(fit_rf)
varImp(fit_rf)
varImpPlot(fit_rf)



plot(rrfImp, top = 20, main='Variable Importance')



att.scores <- random.forest.importance(Result_Type~., data=na.omit(train))
cutoff.biggest.diff(att.scores)

weights <- chi.squared(Result_Type~., data=na.omit(train)) 
print(weights)
subset <- cutoff.k(weights, 25) 
f <- as.simple.formula(subset, "Result_Type") 
print(f)



weights_inf <- information.gain(Result_Type~., data=na.omit(train))
print(weights_inf)
subset_inf <- cutoff.k(weights_inf, 24) 
f_inf <- as.simple.formula(subset_inf, "Result_Type") 
print(f_inf)




base.mod <- lm(Result_Type ~ 1 , data=train)  

# Step 2: Full model with all predictors
all.mod <- lm(Result_Type ~ . , data= train) 

# Step 3: Perform step-wise algorithm. direction='both' implies both forward and backward stepwise
stepMod <- step(base.mod, scope = list(lower = base.mod, upper = all.mod), direction = "both", 
                trace = 0, steps = 1000)  

# Step 4: Get the shortlisted variable.
shortlistedVars <- names(unlist(stepMod[[1]])) 
shortlistedVars <- shortlistedVars[!shortlistedVars %in% "(Intercept)"] # remove intercept


print(shortlistedVars)






#decision tree 1


model_rf <- train(Result_Type ~ Zone1Position + Zone2Position + Zone1_Area + SKU + 
                 Zone1_Col_Num + Zone3Position + Zone2_Col_num + Zone1_Left_Block_Bin + 
                 Zone1_Right_Block_Bin + Zone3_Area + Zone3_Col_Num + Zone1_In_Zone3_Out_Dur + 
                 Zone1_Row_Num + Zone2_Row_Num + Block_Position + Zone3_Temp_Range + 
                 Zone3_Temp_Max + Zone3_Temp_Min + Block_Num + Zone3_Humidity_Range + 
                 Zone3_Humidity_Max + Zone3_Humidity_Min + Zone3_Row_Num + 
                 Zone3_Humidity_Avg, data = train, method = 'rf',
               trControl = trainControl(method = 'cv',number = 3))


rf1 <- randomForest(Result_Type ~ Zone1Position + Zone2Position + Zone1_Area + SKU + 
                     Zone1_Col_Num + Zone3Position + Zone2_Col_num + Zone1_Left_Block_Bin + 
                     Zone1_Right_Block_Bin + Zone3_Area + Zone3_Col_Num + Zone1_In_Zone3_Out_Dur + 
                     Zone1_Row_Num + Zone2_Row_Num + Block_Position + Zone3_Temp_Range + 
                     Zone3_Temp_Max + Zone3_Temp_Min + Block_Num + Zone3_Humidity_Range + 
                     Zone3_Humidity_Max + Zone3_Humidity_Min + Zone3_Row_Num + 
                     Zone3_Humidity_Avg, data=train, ntree = 3,
                   importance = TRUE)

rf1_pred<- predict(rf1, data=test, type = "class")
mean(rf1_pred == test$Result_Type)


library(rpart)
library(rpart.plot)

tm <- rpart(Result_Type ~ Zone1Position + Zone2Position + Zone1_Area + SKU + 
              Zone1_Col_Num + Zone3Position + Zone2_Col_num + Zone1_Left_Block_Bin + 
              Zone1_Right_Block_Bin + Zone3_Area + Zone3_Col_Num + Zone1_In_Zone3_Out_Dur + 
              Zone1_Row_Num + Zone2_Row_Num + Block_Position + Zone3_Temp_Range + 
              Zone3_Temp_Max + Zone3_Temp_Min + Block_Num + Zone3_Humidity_Range + 
              Zone3_Humidity_Max + Zone3_Humidity_Min + Zone3_Row_Num + 
              Zone3_Humidity_Avg, train, method = "class")

tm_pred<- predict(tm, data=test, type = "class")
table_mat <- table(test$Result_Type, tm_pred)
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)