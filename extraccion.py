import pandas as pd

country = pd.read_json(path_or_buf="./country.json") #pagina del json https://restcountries.eu/rest/v2/all
country.to_csv("country.csv", sep=',')

'''
ir a https://sqlizer.io/#/ y convertir el csv a sql (country1.sql)
continuar con extraccion.sql
'''
