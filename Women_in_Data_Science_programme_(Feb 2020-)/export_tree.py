import pandas as pd
import numpy as np
import pydot as pydot
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, DecisionTreeRegressor, export_graphviz
import scipy.cluster.hierarchy as sch
from sklearn.cluster import AgglomerativeClustering
import sklearn.tree as tree
from sklearn.cluster import KMeans
import pydotplus
from sklearn.externals.six import StringIO
from IPython.display import Image
import dtreeviz
from dtreeviz.trees import *

Data = pd.read_csv("Data_processed.csv")

### Encoding categorical variables
categorical_feature_mask = Data.dtypes == object
categorical_cols = Data.columns[categorical_feature_mask].tolist()
le = LabelEncoder()
Data[categorical_cols] = Data[categorical_cols].apply(lambda col: le.fit_transform(col))
target_names = list(le.classes_)

# Model 2 - with reduced features

feature_model2 = ['Zone1Position', 'SKU', 'Zone1_Col_Num', 'Zone3_Col_Num', 'Zone1_In_Zone3_Out_Dur',
                  'Zone3_Temp_Range', 'Zone3_Humidity_Max', 'Zone3_Humidity_Range', 'Block_Num', 'Block_Position']

train, test = train_test_split(Data, test_size=0.2)
x_train = train[feature_model2]
y_train = train["Result_Type"]
x_test = test[feature_model2]
y_test = test["Result_Type"]

rf = DecisionTreeClassifier(max_depth=7)
rf.fit(x_train, y_train)
y_pred = rf.predict(x_test)

# len(Data[(Data.Zone2Position>1.5) & (Data.SKU==0) & (Data.Zone3_Temp_Range>7) & (Data.Result_Type == 0)])
# print(Data[(Data.Zone1Position<=2.5) & (Data.SKU==2) & (Data.Zone1_In_Zone3_Out_Dur <= 99.99) &
#            (Data.Zone1_In_Zone3_Out_Dur > 56.21) & (Data.Zone3_Humidity_Max > 39.87) & (Data.Result_Type != 5)])

# report = classification_report(y_test, y_pred, output_dict=True)
# print(report)
# # report_table = pd.DataFrame(report).transpose()
# # report_table.to_csv("Classification_report.csv")
#
# conf_mat = confusion_matrix(y_test, y_pred)
# print(conf_mat)
# conf_mat_table = pd.DataFrame(conf_mat).transpose()
# conf_mat_table.to_csv("Confusion_matrix.csv")

# Exporting the tree
dot_data = StringIO()

tree.export_graphviz(rf,
 out_file=dot_data,
 class_names= target_names, # the target names.
 feature_names= feature_model2, # the feature names.
 filled=True, # Whether to fill in the boxes with colours.
 rounded=True, # Whether to round the corners of the boxes.
 special_characters=True)

graph = pydotplus.graph_from_dot_data(dot_data.getvalue())
Image(graph.create_svg())

graph.write_svg("tree_exported.svg")
#
# feature_names = list(x_train.columns)
# viz = dtreeviz(rf, x_train, y_train, feature_names=feature_names,
#                target_name="Result_type",
#                class_names=['Defect_1', 'Defect_2', 'Defect_3', 'Defect_4', 'Defect_5', 'PASS'], scale=2)
# viz.view()
#
# from sklearn.tree.export import export_text
# r = export_text(rf, feature_names=feature_model2, show_weights=True)
#
# print(r)
