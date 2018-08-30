import warnings
import csv
import itertools
import math
import pickle
from decimal import *
warnings.filterwarnings("ignore")


def get_signal_loss(freq, dist):
    ##freq in Mhz and dist in miles
    ##equation source: http://www.l-com.com/content/Wireless-Calculators.html
    ##(Free Space Loss Wireless Calculator - Power loss over distance)
    return 36.56 + (20 * math.log10(freq)) + (20 * math.log10(dist))


def get_distance_approximation(freq, desired_signal):
    ##get the distance from the cell tower for which which signal loss is very close in value to desired_signal at a certain frequency
    ##ex. if desired_signal is 0, then the zero-point distance is found, however, desired_signal must always be greater than 0
    ##as negative signal is not possible
    if desired_signal < 0:
        desired_signal = 0
    dist = Decimal(100) #max value possible for distance
    dist_change_factor = 0.1 #the factor used for determining how much to change distance by
    change_add_index = True #used for determining whether to change the index of prev_two_adds
    increase_power = 0 #the amount by which to increase the power by which dist is reduced by
    signal_loss = Decimal(100000) #default value
    prev_two_adds = [False, True] #used for when signal_loss is oscillating around desired_signal as it helps determine when to add to increase_power
    while math.fabs(signal_loss) > 0.00000000000000001 + desired_signal:
        ##small amount added to prevent desired_signal from possibly equaling zero
        signal_loss = Decimal(get_signal_loss(freq, dist)) #gets the signal loss for freq and current dist value
        add = False
        if signal_loss < desired_signal: #if the signal_loss is less than the desired_signal then add to distance to increase signal_loss in the next iteration of the loop
            add = True
        cont = True
        power = 0
        while cont:
            if dist <= Decimal(dist_change_factor) / Decimal(math.pow(10, power)):
                ##determine by how much dist can be reduced
                ##ex. if dist = 15.4, then it will reduce dist by 0.1; if dist = 0.35, then it will reduce dist by 0.01
                power += 1
            else:
                cont = False
        increase_power += 1 if add == prev_two_adds[1] and add != prev_two_adds[0] else 0
        ##if signal_loss is oscillating around desired_signal, then increase the amount by which dist will be reduced
        amount_to_change = Decimal(dist_change_factor) / Decimal(math.pow(10, power + increase_power))
        ##determine by amount that dist will change by
        dist += amount_to_change if add is True else amount_to_change * -1
        ##add or subtract from dist depending on if signal_loss is less than or greater than desired_signal
        if change_add_index == True:
            prev_two_adds[0] = add
        else:
            prev_two_adds[1] = add
    return dist.quantize(Decimal('1.000000000000000000000000')), signal_loss #returns the distance for which signal_loss is very close in value to desired_signal


def convert_miles_to_km(distance):
    return distance * 1.609344


def open_csv(name):
    with open(name) as f:
        reader = csv.reader(f)
        data = list(reader)
    data = data[1:] #remove column names
    return data


def clean_tigo_data(data):
    #remove incomplete data
    return filter(lambda (a, b, c): b != "TBD" and b != "NA" and c != "TBD" and c != "NA", data)


def clean_open_cell_id_data(data):
    #remove non-tigo data
    return filter(lambda (a, b, c, d, e, f, g): c == '2', data)


def get_columns(data, cols):
    #cols should be a list of the indices of the columns wanted from data
    mod_data = list()
    for x in data:
        holder = list()
        for col in cols:
            holder.append(x[col])
        mod_data.append(holder)
    return mod_data


def distance_between_coords(lat1, lon1, lat2, lon2):
    lat_mid = (lat1 + lat2) / 2
    lon_mid = (lon1 + lon2) / 2
    meters_per_deg_lat = 111132.954 - 559.822 * math.cos(2 * lat_mid) + 1.175 * math.cos(4 * lat_mid)
    meters_per_deg_lon = (3.14159265359 / 180) * 6367449 * math.cos(lat_mid)
    delta_lat = math.fabs(lat1 - lat2)
    delta_lon = math.fabs(lon1 - lon2)
    return math.sqrt(math.pow(delta_lat * meters_per_deg_lat, 2) + math.pow(delta_lon * meters_per_deg_lon, 2))


def long_cid_to_short_cid(long_cid):
    ##modulus reduction to get last 16 bits from long_cid to make the short_cid
    return long_cid % (2**16)


def num_to_bin(num):
    ##return binary representation of number
    return bin(int(num))


def num_to_bin_str(num):
    ##return the binary representation of a number (split up by groups of four bits for readability)
    binary_str = str(bin(int(num)))[2:]
    mod_str = ""
    for x in range(0, len(binary_str)):
        if (x + 1) % 5 == 0:
            mod_str += " "
        else:
            mod_str += binary_str[x]
    return mod_str


def put_cell_id_together(cell):
    #puts together open_cell_id data into tigo's format for cell_ids
    return cell[1] + '0' + cell[2] + cell[3] + str(long_cid_to_short_cid(int(cell[4])))


def get_cells_in_area(open_cell_id):
    ##makes a dictionary where the key is the area number and the value is another dictionary where the keys are lte/gsm/umts
    ##and the values are lists of the cells in that area with that technology
    areas = dict()
    for cell in open_cell_id:
        cell.append(put_cell_id_together(cell))
        if cell[3] not in areas.keys():
            areas[cell[3]] = {cell[0]: [cell]}
        else:
            cells_in_area = areas[cell[3]]
            if cell[0] in cells_in_area.keys():
                cell_data = cells_in_area[cell[0]]
                cell_data.append(cell)
                cells_in_area[cell[0]] = cell_data
            else:
                cells_in_area[cell[0]] = [cell]
            areas[cell[3]] = cells_in_area
    return areas


def match_tigo_data(tigo, open_cell_id_areas):
    ##makes a dictionary where the key is the area number and the value is another dictionary where the keys are lte/gsm/umts
    ##and the values are lists of the cells in that area with that technology that also exist in open_cell_id
    tigo_match_data = dict()
    tigo_cell_ids = [element[0] for element in tigo]
    for area in open_cell_id_areas.keys():
        cells = dict()
        for tech in open_cell_id_areas[area].keys():
            tech_dict = open_cell_id_areas[area][tech]
            for cell in open_cell_id_areas[area][tech]:
                if cell[7] in tigo_cell_ids:
                    if tech not in cells.keys():
                        cells[tech] = [cell]
                    else:
                        existing_cells = cells[tech]
                        existing_cells.append(cell)
                        cells[tech] = existing_cells
        tigo_match_data[area] = cells
    return tigo_match_data
    

def write_dict_to_file(data, file_name):
    with open(file_name, "w") as file:
        file.write(pickle.dumps(data))


##the below function has been commented out as it needs to be modified to account for
##us now knowing how to decipher tigo cell_ids

        
##def compare_data(data1, data2):
##    try:
##        longer_data = data1 if len(data1) >= len(data2) else data2
##        shorter_data = data1 if longer_data != data1 else data2
##        positive_results = 0
##        count = 0
##        frequencies = {'GSM': 1900, 'UMTS': 850, 'LTE': 850}
##        distances = dict()
##        for freq in frequencies.keys():
##            max_signal_loss = int(get_signal_loss(frequencies[freq], 100))
##            distance = 0
##            for x in xrange(1, 100, 1):
##                dist, signal_loss = get_distance(frequencies[freq], float(x) / 1)
##                if round(signal_loss) == round(max_signal_loss / 2):
##                     print(frequencies[freq])
##                     print(get_distance(frequencies[freq], float(x) / 1))
##                     distance = convert_miles_to_km(round(dist * 1000))
##                     break
##             distances[freq] = distance
##        tower_matches = dict()
##        for data_long in longer_data:
##            towers = list()
##            count += 1
##            if count % 100 == 0:
##                print(count)
##                print(positive_results)
##            for data_short in shorter_data:
##                distance = distances[data_short[0]]
##                if distance_between_coords(float(data_long[1]), float(data_long[2]), float(data_short[1]), float(data_short[2])) <= distance:
##                    towers.append(data_short)
##                    positive_results += 1
##            tower_matches[data_long[0]] = towers
##        return positive_results, tower_matches     
##    except:
##        print("invalid parameters entered into compare_data")
##        return 0


def main():
    tigo_data = open_csv("data\\Cells.csv")
    open_cell_id_data = open_csv("data\\open_cell_id.csv")
    open_cell_id_data = get_columns(open_cell_id_data, [0, 1, 2, 3, 4, 6, 7])
    tigo_data = get_columns(tigo_data, [0, 1, 2])
    tigo_data = clean_tigo_data(tigo_data)
    open_cell_id_data = clean_open_cell_id_data(open_cell_id_data)
    area_open_cell_id_dict = get_cells_in_area(open_cell_id_data)
    area_tigo_dict = match_tigo_data(tigo_data, area_open_cell_id_dict)
    

main()
