library(nnet)
Data_processed <- read_csv("Women_in_Data_Science_programme_(Feb 2020-)/Data_processed.csv")
Data_processed$Result_Type <- factor(Data_processed$Result_Type, ordered = FALSE )
Data_processed$Result_Type <- relevel(Data_processed$Result_Type, ref = "PASS")

model<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Avg+Zone2_Humidity_Avg+
                  Zone1_Humidity_Avg+Zone3_Temp_Avg+Zone2_Temp_Avg+Zone1_Temp_Avg+Zone2_Dur+
                  Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone2Position+SKU+
                  Zone1_Out_Zone2_In_Dur+Zone2_In_Zone3_Out_Dur+Zone1_In_Zone2_Out_Dur+
                  Zone1_Out_Zone3_In_Dur+Zone2_Out_Zone3_In_Dur+Zone1_In_Zone3_Out_Dur, 
                data = Data_processed)

z <- summary(model)$coefficients/summary(model)$standard.errors

pvalue <- (1 - pnorm(abs(z), 0, 1)) * 2


model<-multinom(Result_Type ~ Block_Position+Block_Num+Zone3_Humidity_Avg+Zone2_Humidity_Avg+
                  Zone1_Humidity_Avg+Zone3_Temp_+Zone2_Temp_Avg+Zone1_Temp_Avg+Zone2_Dur+
                  Zone1_Dur+Zone3_Dur+Zone1Position+Zone2Position+Zone2Position+SKU, 
                data = Data_processed)

z <- summary(model)$coefficients/summary(model)$standard.errors

pvalue <- (1 - pnorm(abs(z), 0, 1)) * 2

stargazer(model, type = "html", style = "apsr", out = "model1.html")
