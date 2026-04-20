import pandas as pd

df = pd.read_csv(r"C:\Users\Rutuja\Downloads\data analysis project\zomato.csv")

df = df[['name', 'location', 'rate', 'votes', 'approx_cost(for two people)', 'cuisines']]
df.columns = ['name', 'location', 'rating', 'votes', 'cost', 'cuisines']

#print(df['rating'].unique())
#cleaning specfic rating column
df = df[df['rating'].notnull()]
df = df[df['rating'] != 'NEW']
df = df[df['rating'] != '-']

#transforming column rating
df['rating'] = df['rating'].str.replace(' ', '')  # remove extra spaces
df['rating'] = df['rating'].str.split('/').str[0]
df['rating'] = df['rating'].astype(float)
print(df.shape)
print(df['rating'].head())
print(df['rating'].dtype)

df['cost'] = df['cost'].astype(str)
df['cost'] = df['cost'].str.replace(',', '')
df['cost'] = df['cost'].str.replace('₹', '')
df['cost'] = df['cost'].astype(float)

print(df['cost'].head())
print(df['cost'].dtype)

df['votes'] = df['votes'].astype(int)
print(df['votes'].head())
print(df['votes'].dtype)

df = df.dropna()
print(df.shape)

df.to_csv("cleaned_zomato.csv", index=False)