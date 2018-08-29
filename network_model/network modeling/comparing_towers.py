import warnings
import csv
import itertools
import math
import pickle
from decimal import *
warnings.filterwarnings("ignore")


def get_signal_loss(freq, dist):
    ##freq in Mhz and dist in miles
    ##equation source: http://www.l-com.com/content/Wireless-Calculators.html (Free Space Loss Wireless Calculator - Power loss over distance)
    return 36.56 + (20 * math.log10(freq)) + (20 * math.log10(dist))


def get_distance(freq, base):
    ##get the distance value for which signal loss equals base at a certain frequency
    ##ex. if base is 0, then the zero-point distance is found
    ##also max value for base is 100 (all distance measurements in miles)
    if base > 100:
        base = 100
    elif base < 0:
        base = 0
    dist = Decimal(100)
    factor = Decimal(100)
    factor_change = 0.1
    change_add_index = True
    increase_power = 0
    signal_loss = Decimal(100000)
    prev_signal_loss = Decimal(100000)
    prev_two_adds = [False, True]
    while math.fabs(signal_loss) > 0.00000000000000001 + base: #small amount added to prevent base from possibly equaling zero
        signal_loss = Decimal(get_signal_loss(freq, factor))
        add = False
        prev_signal_loss = signal_loss
        dist = factor
        if signal_loss < 0:
            add = True
        cont = True
        power = 0
        while cont:
            if factor <= Decimal(factor_change) / Decimal(math.pow(10, power)):
                power += 1
            else:
                cont = False
        increase_power += 1 if add == prev_two_adds[1] and add != prev_two_adds[0] else 0
        amount_to_change = Decimal(factor_change) / Decimal(math.pow(10, power + increase_power))
        factor += amount_to_change if add is True else amount_to_change * -1
        if change_add_index == True:
            prev_two_adds[0] = add
        else:
            prev_two_adds[1] = add
    return dist.quantize(Decimal('1.000000000000000000000000')), signal_loss


def convert_miles_to_km(distance):
    return distance * 1.609344


def open_csv(name):
    try:
        with open(name) as f:
            reader = csv.reader(f)
            data = list(reader)
        data = data[1:] #remove column names
        return data
    except:
        print("invalid file name entered into open_csv")
        return 0


def clean_tigo_data(data):
    #remove incomplete data
    return filter(lambda (a, b, c): b != "TBD" and b != "NA" and c != "TBD" and c != "NA", data)


def clean_open_cell_id_data(data):
    #remove non-tigo data
    return filter(lambda (a, b, c, d, e, f, g): c == '2', data)


def get_columns(data, cols):
    #cols should be a list of the indices of the columns wanted from data
    try:
        mod_data = list()
        for x in data:
            holder = list()
            for col in cols:
                holder.append(x[col])
            mod_data.append(holder)
        return mod_data
    except:
        print("invalid parameters entered into get_columns")
        return 0


def distance_between_coords(lat1, lon1, lat2, lon2):
    lat_mid = (lat1 + lat2) / 2
    lon_mid = (lon1 + lon2) / 2
    meters_per_deg_lat = 111132.954 - 559.822 * math.cos(2 * lat_mid) + 1.175 * math.cos(4 * lat_mid)
    meters_per_deg_lon = (3.14159265359 / 180) * 6367449 * math.cos(lat_mid)
    delta_lat = math.fabs(lat1 - lat2)
    delta_lon = math.fabs(lon1 - lon2)
    return math.sqrt(math.pow(delta_lat * meters_per_deg_lat, 2) + math.pow(delta_lon * meters_per_deg_lon, 2))


def long_cid_to_short_cid(long_cid):
    #modulus reduction to get last 16 bits from long_cid to make the short_cid
    return long_cid % (2**16)


def num_to_bin(num):
    #return binary representation of number
    return bin(int(num))


def num_to_bin_str(num):
    #return the binary representation of a number (split up by groups of four bits for readability)
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


def main():
    tigo_data = open_csv("C:\\Users\\alexa\\Desktop\\Guatemala\\data\\Cells.csv")
    open_cell_id_data = open_csv("C:\\Users\\alexa\\Desktop\\Guatemala\\data\\open_cell_id.csv")
    open_cell_id_data = get_columns(open_cell_id_data, [0, 1, 2, 3, 4, 6, 7])
    tigo_data = get_columns(tigo_data, [0, 1, 2])
    tigo_data = clean_tigo_data(tigo_data)
    open_cell_id_data = clean_open_cell_id_data(open_cell_id_data)
    area_open_cell_id_dict = get_cells_in_area(open_cell_id_data)
    area_tigo_dict = match_tigo_data(tigo_data, area_open_cell_id_dict)
    

main()
