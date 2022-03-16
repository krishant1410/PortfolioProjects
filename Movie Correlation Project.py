#!/usr/bin/env python
# coding: utf-8

# In[97]:


#Import Libraries

import pandas as pd
import numpy as np
import seaborn as sns

import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import matplotlib
plt.style.use('ggplot')
from matplotlib.pyplot import figure

get_ipython().run_line_magic('matplotlib', 'inline')
matplotlib.rcParams['figure.figsize'] = (12,8)

pd.options.mode.chained_assignment = None

#now we read in the data
df =pd.read_csv(r'C:\Users\surat\Desktop\Data anlyst project\Part 4-Python Correlation\movies.csv')


# In[98]:


#let's look at the data
df.head()


# In[99]:


# Check if there is any missing data

for col in df.columns:
    pct_missing = np.mean(df[col].isnull())
    print('{} - {}%'.format(col, pct_missing))
          


# In[100]:


# Data Types for our columns

df.dtypes


# In[101]:


#Change Data types of columns
df['budget'] = df['budget'].fillna(0)
df['gross'] = df['gross'].fillna(0)


# In[103]:



df['budget'] = df['budget'].astype('int64')
df['gross'] = df['gross'].astype('int64')


# In[24]:





# In[104]:


#Create Correct Year Column and filling the year
df['yearcorrect']=df['released'].astype(str).str[-20:-16]


# In[105]:


df.head()


# In[106]:


df.sort_values(by=['gross'], inplace=False, ascending=False ).head()


# In[107]:


pd.set_option('display.max_rows',None)


# In[108]:


#Drop any duplicates

df['company'].drop_duplicates().sort_values(ascending=False)


# In[109]:


df.head()


# In[ ]:





# In[ ]:


# Budget high correlation
# Company high correlation


# In[110]:


#scatter plot with budget vs gross
plt.scatter(x=df['budget'],y=df['gross'])
plt.title('Budget vs Gross Earnings')
plt.xlabel('Budget for film')
plt.ylabel('Gross Earnings')
plt.show()


# In[111]:


df.sort_values(by=['gross'], inplace=False, ascending=False ).head()


# In[112]:


#Plot budget vs gross using seaborn
sns.regplot(x='budget', y='gross', data=df, scatter_kws={"color":"red"},line_kws={"color":"blue"})


# In[ ]:


# Let's start looking at correlations


# In[113]:


df.corr(method='pearson') #Pearson, Kendall, spearman


# In[ ]:


#High Correlation between budget and gross
#visualization correlation matrix


# In[114]:


correlation_matrix =df.corr(method='pearson')
sns.heatmap(correlation_matrix, annot =True)
plt.title('correlation Matric for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[115]:


#look at Company
df.head()


# In[ ]:





# In[116]:


df_numerized = df
for col_name in df_numerized.columns:
    if(df_numerized[col_name].dtype == 'object'):
        df_numerized[col_name]=df_numerized[col_name].astype('category')
        df_numerized[col_name]=df_numerized[col_name].cat.codes
        
df_numerized.head()


# In[89]:


correlation_matrix =df_numerized.corr(method='pearson')
sns.heatmap(correlation_matrix, annot =True)
plt.title('correlation Matric for Numeric Features')
plt.xlabel('Movie Features')
plt.ylabel('Movie Features')
plt.show()


# In[117]:


df_numerized.corr()


# In[118]:


#unstacking
correlation_mat=df_numerized.corr()
corr_pairs=correlation_mat.unstack()
sorted_pairs=corr_pairs.sort_values()
sorted_pairs


# In[119]:


high_corr = sorted_pairs[(sorted_pairs)>0.5]
high_corr


# In[ ]:


# Budget and gross have the highest correlations to votes and gross
# Company has low correlation

