import warnings
warnings.filterwarnings("ignore")
import csv
import ast
import numpy as np
import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt
import math
#gem columns: 0 = latitude, 1 = longitude, 2 = altitude, 3 = accuracy, 4 = department, 5 = municipality, 6 = household salary, 7 = generally, how do you find out what is going in the country?, 8 = age
#total_towers_within_range.txt is the output of the total_towers_within_range function in network_analysis.py saved to a txt file
def open_csv(name): 
    try:
        with open(name) as f:
            reader = csv.reader(f)
            data = list(reader)
        data = data[1:]
        return data
    except:
        print("invalid file name")
        return 0

def open_dict(name): #open dictionary from a file
    try:
        with open(name) as f:
            reader = f.read()
            data = ast.literal_eval(reader)
        return data
    except:
        print("invalid file name")
        return 0

def convert_dict_to_list(data):
    modified_data = list()
    try:
        for key in data.keys():
            modified_data.append(data[key])
    except:
        print("invalid data entered to convert_dict_to_list")
    return modified_data

def initial_cleanup_gem_data(gem): #cleans up gem data by removing entries with incomplete data
    to_be_removed = list()
    for element in gem:
        try: #checks if entry is complete by checking if the fields contain the correct data type
            data_check = [float(element[0]), float(element[1]), float(element[2]), int(element[3])]
        except:
            to_be_removed.append(element)
    while len(to_be_removed) > 0:
        gem.remove(to_be_removed.pop())
    return gem

def final_cleanup_data(gem, towers): #cleans up gem data by removing entries who refused to answer relevant questions and also removes their data from the towers file
    to_be_removed = list()
    for index in range(0, len(gem)):
        try:
            if int(gem[index][6]) in [-1, -2]:
                to_be_removed.append(index)
        except:
            pass
    while len(to_be_removed) > 0:
        index = to_be_removed.pop()
        del gem[index]
        del towers[index]
    return gem, towers

def get_column(gem, column_num): #from the gem data, get one of the columns
    try:
        data = list()
        for element in gem:
            data.append(element[column_num])
        return data
    except:
        print("invalid inputs to get_column")
        return 0

def convert_income_codes(income): #convert coded income to the midpoint of the range of income they answered with
    data = list()
    try:
        values = {-2:"ref",-1:"idk",1:250,2:625,3:1175,4:1800,5:2250,6:2750,7:4000,8:7500,9:12500,10:17500,11:20000}
        for index in range(0, len(income)):
            data.append(values[int(income[index][0])])
    except:
        print("invalid data entered to convert_income_codes")
    return data

def flag_data(data): #flag data in a column to do logistic regression
    flags = {}
    try:
        for element in data:
            if element not in flags.keys():
                if int(element[0]) == 4 or int(element[0]) == 11: #the chosen values to flag as True, the values here currently mean that the person surveyed primarily uses internet/social media for information
                    flags[element] = True
                else:
                    flags[element] = False
        flagged_data = list()
        for element in data:
            if element in flags.keys():
                flagged_data.append(flags[element])
        return flagged_data
    except:
        print("invalid data entered to flag_data")
        return 0

def log(data, base): #apply log function to a list of the inputed base
    modified_data = list()
    try:
        for element in data:
            modified_data.append(math.log(float(element),base))
    except:
        print("invalid data entered to log")
    return modified_data

def stats(predictor, response, model): 
    try:
        predictor = np.asarray(predictor)
        response = np.asarray(response)
        if model == 'logit':
            model = sm.Logit(predictor, response)
        elif model == 'lsr':
            model = sm.OLS(predictor, response)
        else:
            pass
        model = model.fit()
        print(model.summary())
    except:
        print('invalid parameters entered to stats')

def string_to_int(data): #convert list of strings to list of integers
    modified_data = list()
    try:
        for element in data:
            modified_data.append(int(element))
    except:
        print("invalid data entered to string_to_int")
    return modified_data

def main():
    gem_data = open_csv("data\\gem_data.csv")
    tower_data = open_dict("data\\total_towers_within_range.txt")
    tower_data = convert_dict_to_list(tower_data)
    gem = initial_cleanup_gem_data(gem_data)
    gem, towers = final_cleanup_data(gem, tower_data)
    income = get_column(gem, 6)
    income = convert_income_codes(income)
    internet_use = get_column(gem, 7)
    age = get_column(gem, 8)
    age = string_to_int(age)
    flagged_internet_use = flag_data(internet_use)
    income_logged = log(income, 10)
    towers_logged = log(towers, 10)
    stats(towers_logged, age, 'lsr') #does a least squares regression with the first variable as the predictor and the second variable as the response
    stats(flagged_internet_use, age, 'logit') #does a logistic regression with the first variable being the binary predictor and the second variable as the response
        
main()
