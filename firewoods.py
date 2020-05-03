#.corr me da una matriz con la correlacion entre las variables
#.describe me da varios datos estadisticos
#.dtype me muestra el tipo de dato de cada variable

#print(data.corr(method='pearson'))

import warnings
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, KFold, cross_val_score
from sklearn.tree import DecisionTreeRegressor
from sklearn.svm import SVR
from sklearn.neighbors import KNeighborsRegressor
from sklearn.linear_model import LinearRegression, ElasticNet, Lasso, Ridge

#For nice printing
warnings.filterwarnings('ignore')
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)


#Importar los datos
name = ['X', 'Y', 'month', 'day', 'FFMC', 'DMC', 'DC', 'ISI', 'temp', 'RH', 'wind', 'rain', 'area']
data = pd.read_csv('forestfires.csv', names=name)
data.month.replace(('jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'),range(1,13), inplace=True)
data.day.replace(('mon','tue','wed','thu','fri','sat','sun'), range(1,8), inplace=True)
array = data.values
X = array[:,0:12]
Y = array[:,12]

#Folds and Scoring
num_folds = 10 #number of folds for cross validation training
seed = 7
scoring = 'max_error'
scoring2 = 'neg_mean_absolute_error'
scoring3 = 'r2'
scoring4 = 'neg_mean_squared_error'

#spot check preliminary algorithms
models = []
models.append(('LR', LinearRegression()))
models.append(('LASSO', Lasso()))
models.append(('EN', ElasticNet()))
models.append(('RIDGE', Ridge()))

models.append(('KNN', KNeighborsRegressor()))
models.append(('CART', DecisionTreeRegressor()))
models.append(('SVR', SVR()))

# Evaluate the models
results = []
names = []

for name, model in models:

    kfold = KFold(n_splits = num_folds, random_state = seed)
    cv_results = cross_val_score(model, X,Y, cv=kfold, scoring=scoring)
    cv_results2 = cross_val_score(model, X,Y, cv=kfold, scoring=scoring2)
    cv_results3 = cross_val_score(model, X,Y, cv=kfold, scoring=scoring3)
    cv_results4 = cross_val_score(model, X,Y, cv=kfold, scoring=scoring4)

    msg = "%s: max error: %f, mean absolute error: %f, r2: %f, mean square error: %f" %(name, cv_results.mean(),
     -cv_results2.mean(), cv_results3.mean(), -cv_results4.mean())

    print(msg)
