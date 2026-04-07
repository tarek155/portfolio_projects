import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


# import data into dataframe

df = pd.read_csv(r"D:\TAREK HAWELA\MASTER DEGREE\AI\data analysis\portfolio projects\movie_industry_analysis\movies.csv")
df.head()


# processing missing data
 
df.isnull().sum()

df['budget']=df['budget'].fillna(df['budget'].mean())
df['budget'].isna().sum()

df['gross']=df['gross'].fillna(df['gross'].mean())
df['gross'].isna().sum()

df['runtime']=df['runtime'].fillna(df['runtime'].mean())
df['runtime'].isna().sum()

df.shape
df.dropna(subset=['rating','company'],inplace=True)


# inserting profit columns

df.insert(3, 'profit', df.gross-df.budget)
df.insert(4, 'roi', df.profit/df.budget)


# visualization

df1 = df[['budget','gross','profit','roi','votes']]
df1.hist(bins = 20 , figsize=(14,12))

# finding correlations in data 

plt.scatter(x=df['budget'], y=df['gross'])
plt.title('budget vs gross')
plt.xlabel('gross earnings')
plt.ylabel('budget for film')
plt.show()

sns.regplot(x='budget', y='gross', data=df, scatter_kws={'color':'red'}, line_kws={'color':'blue'})



