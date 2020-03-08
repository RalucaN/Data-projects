library(nnet)
library(stargazer)
library(car)

Data_processed <- read_csv("Women_in_Data_Science_programme_(Feb 2020-)/Data_processed.csv")
Data_processed$Result_Type <- factor(Data_processed$Result_Type, ordered = FALSE )
Data_processed$Result_Type <- relevel(Data_processed$Result_Type, ref = "PASS")

model<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Avg+Zone2_Humidity_Avg+
                  Zone1_Humidity_Avg+Zone3_Temp_Avg+Zone2_Temp_Avg+Zone1_Temp_Avg+Zone2_Dur+
                  Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone3Position+SKU, 
                data = Data_processed)

model2<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Min+Zone2_Humidity_Min+
                  Zone1_Humidity_Min+Zone3_Temp_Min+Zone2_Temp_Min+Zone1_Temp_Min+Zone2_Dur+
                  Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone3Position+SKU, 
                data = Data_processed)

model3<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Max+Zone2_Humidity_Max+
                   Zone1_Humidity_Max+Zone3_Temp_Max+Zone2_Temp_Max+Zone1_Temp_Max+Zone2_Dur+
                   Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone3Position+SKU, 
                 data = Data_processed)

model4<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Range+Zone2_Humidity_Range+
                   Zone1_Humidity_Range+Zone3_Temp_Range+Zone2_Temp_Range+Zone1_Temp_Range+Zone2_Dur+
                   Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone3Position+SKU, 
                 data = Data_processed)

model5<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Range+Zone2_Humidity_Range+
                   Zone1_Humidity_Range+Zone3_Temp_Range+Zone2_Temp_Range+Zone1_Temp_Range+Zone2_Dur+
                   Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone3Position+SKU+
                   Zone1_Out_Zone2_In_Dur+Zone2_In_Zone3_Out_Dur+Zone1_In_Zone2_Out_Dur+
                   Zone1_Out_Zone3_In_Dur+Zone2_Out_Zone3_In_Dur+Zone1_In_Zone3_Out_Dur, 
                 data = Data_processed)

model6<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Range+Zone2_Humidity_Range+
                   Zone1_Humidity_Range+Zone3_Temp_Range+Zone2_Temp_Range+Zone1_Temp_Range+Zone2_Dur+
                   Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone3Position+SKU+
                   Zone1_Out_Zone2_In_Dur+Zone2_In_Zone3_Out_Dur+
                   Zone1_Out_Zone3_In_Dur+Zone2_Out_Zone3_In_Dur, 
                 data = Data_processed)

model7<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Avg+Zone2_Humidity_Avg+
                  Zone1_Humidity_Avg+Zone3_Temp_Avg+Zone2_Temp_Avg+Zone1_Temp_Avg+
                   Zone1Position+Zone2Position+Zone3Position+SKU, 
                data = Data_processed)

model8<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Avg+Zone2_Humidity_Avg+
                   Zone1_Humidity_Avg+Zone3_Temp_Avg+Zone2_Temp_Avg+Zone1_Temp_Avg+
                   Zone1Position+Zone2Position+Zone3Position+SKU+
                   Zone1_Out_Zone2_In_Dur+Zone2_In_Zone3_Out_Dur+
                   Zone1_Out_Zone3_In_Dur+Zone2_Out_Zone3_In_Dur, 
                 data = Data_processed)

stargazer(model, model2,model3,model4, model5, model6, type = "html", style = "apsr", 
          out = "model1_6.html")

#model4 has the best fit due to a lower AIC

stargazer(model4, type = "html", style = "apsr", out = "model4.html")

stargazer(model7, model8, type = "html", style = "apsr", 
          out = "model7_8.html")