import warnings
warnings.filterwarnings("ignore")
import csv
import ast
import numpy as np
import pandas as pd
import math
import statsmodels.api as sm
import matplotlib.pyplot as plt


##this program is an outdated and messier precursor to the program data_analysis_gem.py
##this file remains as reference and should not be used for anything else in its present state


def open_csv(name): 
    try:
        with open(name) as f:
            reader = csv.reader(f)
            data = list(reader)
        data = data[1:]
        return data
    except:
        raise Exception('invalid parameters in open_csv')

    
def open_dict(name): #opens a dictionary from a file
    try:
        with open(name) as f:
            reader = f.read()
            data = ast.literal_eval(reader)
        return data
    except:
        raise Exception('invalid parameters in open_dict')


def get_list(data):
    modified_data = list()
    for element in data:
        modified_data.append(element[0])
    return modified_data


def get_income_tower_data(income_data, tower_data): #combines the data from the tower file into a list with the data from the income file (also changes the codes in the income file into the midpoint of its corresponding range)
    data = list()
##    try:
##        #income_ranges = {-2:"refused", -1:"idk",1:"0-500",2:"501-750",3:"751-1600",4:"1601-2000",5:"2001-2500",6:"2501-3000",7:"3001-5000",8:"5001-10000",9:"10001-15000",10:"15001-20000",11:"20000+"}
##        income = {-2:"ref",-1:"idk",1:250,2:625,3:1175,4:1800,5:2250,6:2750,7:4000,8:7500,9:12500,10:17500,11:20000}
##        for key in tower_data.keys():
##            data.append([income[int(income_data[key][0])], tower_data[key]])
##    except:
##        print("invalid data entered")
    try:
        income = {-2:"ref",-1:"idk",1:250,2:625,3:1175,4:1800,5:2250,6:2750,7:4000,8:7500,9:12500,10:17500,11:20000}
        for index in range(0, len(income_data)):
            data.append([income[int(income_data[index][0])]])
    except:
        raise Exception('invalid parameters in get_income_tower_data')
    return data, tower_data


def separate_data(income_data, tower_data): #separates the list with both tower and income into two separate lists and also applies a log function to all of the values in the list
    income = list()
    towers = list()
    towers_raw = list() #full list of towers with no removal and no log applied
    removed_indices = set()
    try:
        for index in range(0, len(income_data)):
            #towers_raw.append(math.log10(float(element[1])))
            #towers_raw.append(towers[index][1])
            if isinstance(income_data[index][0], int): #gets rid of all non integer values in the data by checking if the income was reported or not (people who did not answer what their income was are removed from the dataset)
                income.append(math.log10(float(income_data[index][0])))
                try:
                    towers.append(math.log10(float(tower_data[index])))
                except:
                    pass
            else:
                removed_indices.add(index)
    except:
        raise Exception('invalid parameters in separate_data')
    return income, towers, towers_raw, removed_indices


def least_squares(x, y): #x = predictor y = response
    try:
        x = np.asarray(x)
        y = np.asarray(y)
        #x = sm.add_constant(x)
        model = sm.OLS(y,x) #ordinary least square regression
        model = model.fit()
        print(model.summary())
        plt.scatter(x, y)
        plt.show()
    except:
        raise Exception('invalid parameters in least_squares')


def clean_gem_data(data, income):
    to_be_removed = list()
    removed_indices = set()
    for index in range(0, len(data)):
        try:
            data_check = [float(data[index][0]), float(data[index][1]), float(data[index][2]), int(data[index][3])]
            if int(income[index][0]) == -1 or int(income[index][0]) == -2:
                removed_indices.add(index)
                to_be_removed.append(data[index])
        except:
            removed_indices.add(index)
            to_be_removed.append(data[index])
    while len(to_be_removed) > 0:
        data.remove(to_be_removed.pop())
    internet_usage = list()
    age = list()
    for element in data:
        internet_usage.append([element[7]])
        age.append([int(element[8])])
    return internet_usage, age, removed_indices


def flag_gem_data(data): #allows you to flag certain codes in a given column as either true or false
    flags = dict()
    try:
        for element in data:
            if element not in flags.keys():
                if int(element[0]) == 4 or int(element[0]) == 11 or int(element[0]) == 10: #codes that are chosen to be set to true
                    flags[element[0]] = True
                else:
                    flags[element[0]] = False
            else:
                continue
    except:
        print("invalid data entered")
    return flags


def apply_flags(data, flags): #generates a list with all values changed to true or false depending on supplied flag dictionary
    flagged_data = list()
    try:
        for element in data:
            if element[0] in flags.keys():
                flagged_data.append(flags[element[0]])
    except:
        raise Exception('invalid parameters in apply_flags')
    return flagged_data


def logit_regression(x, y):
    try:
        x = np.asarray(x)
        y = np.asarray(y)
        model = sm.Logit(x, y)
        model = model.fit()
        print(model.summary())
        plt.scatter(x, y)
        plt.show()
    except:
        print("invalid parameters entered")
    x = np.asarray(x)
    y = np.asarray(y)
    model = sm.Logit(x, y)
    model = model.fit()
    print(model.predict())
    #plt.scatter(x, y)
    #plt.show()
    

def main():
    income_data = open_csv("data\\income.csv")
    tower_data = open_dict("data\\total_towers_within_range.txt")
    gem_data = open_csv("data\\gem_data.csv")
    internet_use, ages, index1 = clean_gem_data(gem_data, income_data)
    #print(len(income_data))
    #print(len(tower_data))
    income, towers = get_income_tower_data(income_data, tower_data)
    income, towers, towers_raw, index2 = separate_data(income, towers)
    #print(len(income))
    #print(len(towers))
    #print(len(internet_use))
    #print(len(ages))
    #print(len(income))
    print(len(index1))
    print(len(index2))
    ages = get_list(ages)          
    internet_flags = flag_gem_data(internet_use)
    flagged_internet_data = apply_flags(internet_use, internet_flags)
    #print(len(flagged_gem_data))
    #print(len(income))
    #least_squares(internet_use, ages)
    #print(len(flagged_internet_data))
    #logit_regression(flagged_internet_data, ages)
    logit_regression(flagged_internet_data, towers)


main()
