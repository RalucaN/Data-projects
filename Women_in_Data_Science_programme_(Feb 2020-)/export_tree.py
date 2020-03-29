import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
import sklearn.tree as tree
import pydotplus
from sklearn.externals.six import StringIO
from IPython.display import Image


Data = pd.read_csv("Data_processed.csv")

### Encoding categorical variables
categorical_feature_mask = Data.dtypes==object
categorical_cols = Data.columns[categorical_feature_mask].tolist()
le = LabelEncoder()
Data[categorical_cols] = Data[categorical_cols].apply(lambda col: le.fit_transform(col))
target_names = list(le.classes_)

#Model 2 - with reduced features

feature_model2 = ['Zone1Position','SKU','Zone1_Col_Num','Zone3_Col_Num','Zone1_In_Zone3_Out_Dur','Zone3_Temp_Range',
                  'Zone3_Humidity_Max', 'Zone3_Humidity_Range', 'Block_Num', 'Block_Position']

train, test = train_test_split(Data, test_size = 0.2)
x_train = train[feature_model2]
y_train = train["Result_Type"]
x_test = test[feature_model2]
y_test = test["Result_Type"]

rf = DecisionTreeClassifier(max_depth=7)
rf.fit(x_train, y_train)
y_pred = rf.predict(x_test)

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
