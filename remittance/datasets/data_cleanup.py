import csv
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec

one = "guatemala"; two = "el progreso"; three = "sacatepequez"; four = "chimaltenango";
five = "escuintla"; six = "santa rosa"; seven = "solola"; eight = "totonicapan"; nine = "quetzaltenango";
ten = "suchitepequez"; eleven = "retalhuleu"; twelve = "san marcos"; thirteen = "huehuetenango";
fourteen = "quiche"; fifteen = "baja verapaz"; sixteen = "alta verapaz"; seventeen = "peten";
eighteen = "izabal"; nineteen = "zacapa"; twenty = "chiquimula"; twenty_one = "jalapa"; twenty_two = "jutiapa";

labels = one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen, fourteen, fifteen, sixteen, seventeen, eighteen, nineteen, twenty, twenty_one, twenty_two
my_list = my_list[1:]

##list below of all the departments in order to make it easier to know what corresponds to what
##1 = Guatemala
##2 = El Progreso
##3 = Sacatepequez
##4 = Chimaltenango
##5 = Escuintla
##6 = Santa Rosa
##7 = Solola
##8 = Totonicapan
##9 = Quetzaltenango
##10 = Suchitepequez
##11 = Retalhuleu
##12 = San Marcos
##13 = Huehuetenango
##14 = Quiche
##15 = Baja Verapaz
##16 = Alta Verapaz
##17 = Peten
##18 = Izabal
##19 = Zacapa
##20 = Chiquimula
##21 = Jalapa
##22 = Jutiapa
def open_data():
    with open("remittance_data.csv","rb") as f: #read in csv file and put in list
        reader = csv.reader(f)
        my_list = list(reader)
def clean_data():
    elements_to_remove = list()
    for element in my_list: #1 corresponds to saying that they do receive international remittances
        if element[0] != "1":
            elements_to_remove.append(element)
    while len(elements_to_remove) > 0:
        my_list.remove(elements_to_remove.pop())
    existing_nums = list()
    for element in my_list: #consolidates the data from the individual level to the household level as often times multiple people in the same household report the same remittances
        if element[3] not in existing_nums: #element[3] is household number which is a unique identification number given to each household
            existing_nums.append(element[3])
        else:
            elements_to_remove.append(element)

    while len(elements_to_remove) > 0:
        my_list.remove(elements_to_remove.pop())
def determine_basic_stats(): #extrapolates the data to the entire population using the factor determined in extrapolation_info.txt to aproximate the amount of remittances per department, the percent of the nationwide remittance amount that department receives, and the total remittance amount that department receives
    dep_freq = list() 
    for x in range(0, 22): #generates a base list
        dep_freq.append([0, 0])

    for element in my_list:
        dep = int(element[2]) - 1 #element[2] is the department of the household
        amount = int(float(element[1])) #element[1] is the amount the household receives
        if(dep_freq[dep] != [0, 0]):
            amount += dep_freq[dep][1]
        dep_freq[dep] = [1 + dep_freq[dep][0], amount] #keeps track of the number of households receiving remittances in each department and the total amount that department receives

    tot_amount = 0
    for element in dep_freq: #calculates total remittances nationwide
        tot_amount += element[1]
    fracs = list()
    for element in dep_freq: #gets the percentage of total remittances nationwide for each department
        fracs.append((float(element[1]) / tot_amount) * 100)

    for x in range(0, 22):
        print("Department: " + labels[x] + " Amount of Remittances: " + str(dep_freq[x][1] * 285.856186) + " and Percent of Total Remittances: " + str(fracs[x]) + " and Total Remittance Receivers in Department: " + str(dep_freq[x][0] * 285.856186))

def main():
    open_data()
    clean_data()
    determine_basic_stats()

