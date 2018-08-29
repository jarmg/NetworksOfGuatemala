import warnings
warnings.filterwarnings("ignore")
import csv
import ast
import numpy as np
import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt
import math


#gem columns: 0 = latitude, 1 = longitude, 2 = altitude, 3 = accuracy, 4 = department, 5 = municipality, 6 = household salary, 7 = JG2, 8 = age, 9 = JG6, 10 = gender
#total_towers_within_range.txt is the output of the total_towers_within_range function in network_analysis.py saved to a txt file

#0 = latitude
#1 = longitude
#2 = altitude
#3 = accuracy
#4 = department
#5 = municipality
#6 = salary
#7 = generally, how do you find out what is going in the country
#8 = age
#9 = If I had access to a better internet service, what would be the main use I would give it? In what activity would its use increase?
#10 = gender
#11 = marital status
#12 = ethnicity
#13 = religious denomination
#14 = does your household have cell phone access
#15 = does your household have a landline
#16 = does your household have internet access


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


def open_dict(name):
    ##open dictionary from a file, untested with not txt files
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


def initial_cleanup_gem_data(gem):
    ##cleans up gem data by removing entries with incomplete data
    to_be_removed = list()
    for element in gem:
        try: #checks if entry is complete by checking if the fields contain the correct data type
            data_check = [float(element[0]), float(element[1]), float(element[2]), int(element[3])]
        except:
            to_be_removed.append(element)
    while len(to_be_removed) > 0:
        gem.remove(to_be_removed.pop())
    return gem


def final_cleanup_data(gem, towers):
    ##cleans up gem data by removing entries who refused to answer relevant questions and also removes their data from the towers file
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


def get_column(gem, column_num):
    ##from the gem data, get one of the columns
    try:
        data = list()
        for element in gem:
            data.append(element[column_num])
        return data
    except:
        print("invalid inputs to get_column")
        return 0


def convert_income_codes(income):
    ##convert coded income to the midpoint of the range of income they answered with
    data = list()
    try:
        values = {-2:"ref",-1:"idk",1:250,2:625,3:1175,4:1800,5:2250,6:2750,7:4000,8:7500,9:12500,10:17500,11:20000}
        for index in range(0, len(income)):
            data.append(values[int(income[index][0])])
    except:
        print("invalid data entered to convert_income_codes")
    return data


def flag_data(data, flagged_numbers):
    ##flag data in a column to do logistic regression, flagged numbers should be a list of numbers to be flagged
    flags = {}
    try:
        for element in data:
            if element not in flags.keys():
                if int(element) in flagged_numbers:
                    #the chosen values to flag as True, the values here currently mean that the person surveyed primarily uses internet/social media for information
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


def log(data, base):
    ##apply log function to a list of the inputed base
    modified_data = list()
    try:
        for element in data:
            modified_data.append(math.log(float(element),base))
    except:
        print("invalid data entered to log")
    return modified_data


def stats(predictor, response, model):
    ##will apply the statistical model you enter to the variables inputed, the codes for each statistical model are viewable in the chain of if statements
    try:
        predictor = np.asarray(predictor)
        response = np.asarray(response)
        if model == 'logit':
            model = sm.Logit(predictor, response)
        elif model == 'lsr':
            model = sm.OLS(predictor, response)
        elif model == "probit":
            model = sm.Probit(predictor, response)
        elif model == "gls":
            model = sm.GLS(predictor, response)
        elif model == "glsar":
            model = sm.GLSAR(predictor, response)
        elif model == "quantreg":
            model = sm.QuantReg(predictor, response)
        else:
            pass
        model = model.fit()
        print(model.summary()) #instead of printing the model summary, should return the model with the predict function as printing it here only allows you to view the summary rather than use it for anything
    except:
        print('invalid parameters entered to stats')


def string_to_int(data):
    ##convert list of strings to list of integers
    modified_data = list()
    try:
        for element in data:
            modified_data.append(int(element))
    except:
        print("invalid data entered to string_to_int")
    return modified_data


def combine_lists(data):
    ##a list of n lists, each of size m will turn into a list of m lists, each of size n - i.e. [[1, 2, 3], [1, 2, 3]] -> [[1, 1], [2, 2], [3, 3]]
    try:
        combined_data = list()
        for x in range(0, len(data[0])):
            inner_list = list()
            for y in range(0, len(data)):
                inner_list.append(data[y][x])
            combined_data.append(inner_list)
        return combined_data
    except:
        print("invalid data entered to combine_lists")
        return data


def main():
    gem_data = open_csv("data\\gem_data.csv")
    tower_data = open_dict("data\\total_towers_within_range.txt")
    tower_data = convert_dict_to_list(tower_data)
    gem = initial_cleanup_gem_data(gem_data)
    gem, towers = final_cleanup_data(gem, tower_data)
    
    income = get_column(gem, 6)
    income = convert_income_codes(income)
    
    internet_use = get_column(gem, 9)
    internet_use = flag_data(internet_use, [4])

    age = get_column(gem, 8)
    age = string_to_int(age)

    gender = get_column(gem, 10)
    gender = string_to_int(gender)
    gender = flag_data(gender, [1])

    marital_status = get_column(gem, 11)
    marital_status = string_to_int(marital_status)
    marital_status = flag_data(marital_status, [2, 5])

    religion = get_column(gem, 13)
    religion = string_to_int(religion)
    religion = flag_data(religion, [1, 2, 3])

    cell_phone_access = get_column(gem, 14)
    cell_phone_access = string_to_int(cell_phone_access)
    cell_phone_access = flag_data(cell_phone_access, [6])

    landline_access = get_column(gem, 15)
    landline_access = string_to_int(landline_access)
    landline_access = flag_data(landline_access, [1])

    internet_access = get_column(gem, 16)
    internet_access = string_to_int(internet_access)
    internet_access = flag_data(internet_access, [1])

    income_logged = log(income, 10)
    towers_logged = log(towers, 10)
    
    demographics = combine_lists([towers, income, age, gender, marital_status, religion])
    demographics = sm.add_constant(demographics)
    #stats(towers_logged, demographics, 'lsr') #does a least squares regression with the first variable as the predictor and the second variable as the response
    #stats(towers_logged, demographics, 'gls')
    #stats(towers_logged, demographics, 'glsar')
    #stats(towers_logged, demographics, 'quantreg')
    #stats(internet_access, demographics, 'logit') #does a logistic regression with the first variable being the binary predictor and the second variable as the response
    #stats(internet_access, demographics, 'probit')   


main()
