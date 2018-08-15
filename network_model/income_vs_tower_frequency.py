import csv
import ast
import numpy as np
import pandas as pd
import statsmodels.api as sm

def open_csv(name): 
    with open(name) as f:
        reader = csv.reader(f)
        data = list(reader)
    data = data[1:]
    return data
def open_dict(name):
    with open(name) as f:
        reader = f.read()
        data = ast.literal_eval(reader)
    return data

def get_income_tower_data(income_data, tower_data):
    data = list()
    income_ranges = {-2:"refused", -1:"idk",1:"0-500",2:"501-750",3:"751-1600",4:"1601-2000",5:"2001-2500",6:"2501-3000",7:"3001-5000",8:"5001-10000",9:"10001-15000",10:"15001-20000",11:"20000+"}
    for key in tower_data.keys():
        
        data.append([income_ranges[int(income_data[key][0])], tower_data[key]])
    return data

def main():
    income_data = open_csv("C:\\Users\\alexa\Desktop\\Guatemala\\data\\income.csv")
    tower_data = open_dict("C:\\Users\\alexa\\Desktop\\Guatemala\\data\\total_towers_within_range.txt")
    combined_data = get_income_tower_data(income_data, tower_data)
    print(combined_data)
    
main()
