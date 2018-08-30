import csv
import math
import pickle

def open_csv(name): 
    with open(name) as f:
        reader = csv.reader(f)
        data = list(reader)
    data = data[1:]
    #cell file: 0 = cell ID, 1 = latitude, 2 = longitude, 3 = state, 4 = city
    #gps file: 0 = latitude, 1 = longitude, 2 = altitude, 3 = accuracy, 4 = department, 5 = municipality
    return data


def clean_cell_data(data):
    ##remove incomplete entries
    to_be_removed = list()
    for cell in data:
        if cell[1] == "TBD" or cell[1] == "NA" or cell[2] == "TBD" or cell[2] == "TBD" or cell[3] == "TO BE DETERMINED":
            to_be_removed.append(cell)
        elif cell[3] == "GUATEMALA":
            to_be_removed.append(cell)
        else:
            cell[3] = cell[3].lower()
            cell[4] = cell[4].lower()
    while(len(to_be_removed) > 0):
        data.remove(to_be_removed.pop())
    return data


def make_cell_data_dict(data):
    ##make a dictionary out of cell_data list
    cell_data = dict()
    for cell in data:
        cell_data[cell[0]] = [cell[1], cell[2], cell[3], cell[4]]
    return cell_data


def get_cell_coords(data):
    ##return coords from data dict
    coords = dict()
    for cell_id in data.keys():
        coords[cell_id] = [data[cell_id][0], data[cell_id][1]]
    return coords


def clean_gps_data(data):
    ##remove incomplete entries
    to_be_removed = list()
    for gps in data:
        try:
            gps_check = [float(gps[0]), float(gps[1]), float(gps[2]), int(gps[3]), int(gps[4]), int(gps[5])]
        except ValueError:
            to_be_removed.append(gps)
    while(len(to_be_removed) > 0):
        data.remove(to_be_removed.pop())
    data = decode_gps_data(data)
    return data

def parse_dep_muni_data(data):
    ##convert list of department/municipalities into a dictionary
    loc_data = dict()
    for loc in data:
        loc_data[loc[1]] = loc[0]
    return loc_data


def decode_gps_data(data):
    ##convert the numerical values that represent departments and municipalities into their actual names
    departments = open_csv("data\\departments.csv")
    municipalities = open_csv("data\\municipalities.csv")
    dep_dict = parse_dep_muni_data(departments)
    muni_dict = parse_dep_muni_data(municipalities)
    zona = list()
    for x in range(1, 26):
        zona.append("Zona " + str(x))
    gps_data = list()
    for person in data:
        if person[4] in dep_dict.keys():
            person[4] = dep_dict[person[4]]
        else:
            continue
        if person[5] in muni_dict.keys():
            person[5] = muni_dict[person[5]]
            if person[5] in zona:
                person[5] = "Guatemala"
        else:
            continue
        gps_data.append(person)
    return gps_data


def get_state_data(data):
    ##make a dictionary where the department/state is the key and the value is a list containing a list of cities, a list of latitudes, a list of longitudes, and a list of cell IDs
    ##there are 22 states out of 22 possibilities and 337 cities out of 340 possibilities in this data set
    states = dict()
    states[data[0][3]] = [[data[0][4]], [float(data[0][1])], [float(data[0][2])], [data[0][0]]]
    for call in data[1:]:
        if call[3] in states.keys():
            if call[4] not in states[call[3]][0]:
                call_data = states[call[3]]
                call_data[0].append(call[4])
                call_data[1].append(float(call[1]))
                call_data[2].append(float(call[2]))
                call_data[3].append(call[0])
                states[call[3]] = call_data
            else:
                continue
        else:
            states[call[3]] = [[call[4]], [float(call[1])], [float(call[2])], [call[0]]]
    return states


def get_city_data(data):
    ##make a dictionary where the city/municipality is the key and the value is a list of the state, a list of latitudes, a list of longitudes, and a list of cell IDs
    cities = dict()
    cities[data[0][4]] = [data[0][3], [float(data[0][1])], [float(data[0][2])], [data[0][0]]]
    for call in data[1:]:
        if call[4] in cities.keys():
            call_data = cities[call[4]]
            call_data[1].append(float(call[1]))
            call_data[2].append(float(call[2]))
            call_data[3].append(call[0])
            cities[call[4]] = call_data
        else:
            cities[call[4]] = [call[3], [float(call[1])], [float(call[2])], [call[0]]]
    return cities


def get_avg_coords(locations):
    ##average the coordinates of whatever is inputed, guaranteed to work on city and state data, however, has not been tested on anything else
    avg_coords = dict()
    for key in locations.keys():
        cell_data = locations[key]
        avg_lat = sum(cell_data[1]) / len(cell_data[1])
        avg_lon = sum(cell_data[2]) / len(cell_data[2])
        avg_coords[key] = [avg_lat, avg_lon]
    return avg_coords


def get_closest_location(coordinates, lat, lon):
    ##get the approximate closest city/state/tower to an inputed latitude and longitude
    coord = [lat, lon]
    closest_location = ""
    closest_coords = [float("inf"), float("inf")]
    closest_distance = float("inf")
    for key in coordinates.keys():
        distance = coords_to_metric(lat, lon, coordinates[key][0], coordinates[key][1])
        if distance < closest_distance:
            closest_distance = distance
            closest_location = key
            closest_coords[0] = coordinates[key][0]
            closest_coords[1] = coordinates[key][1]
            print(closest_location + " " + str(distance))
    print(closest_location)
    print(closest_coords)
    return closest_location, closest_coords


def coords_to_metric(lat1, lon1, lat2, lon2):
    ##the limitations of this formula is that it is within 0.6 meters accurate for 100 kilometers longitudinally and 1 centimeter accurate for 100 kilometers latitudinally
    ##source: http://en.wikipedia.org/wiki/Lat-lon
    lat_mid = (lat1 + lat2) / 2
    lon_mid = (lon1 + lon2) / 2
    m_per_deg_lat = 111132.954 - 559.822 * math.cos(2 * lat_mid) + 1.175 * math.cos(4 * lat_mid)
    m_per_deg_lon = (3.14159265359 / 180) * 6367449 * math.cos(lat_mid)
    delta_lat = math.fabs(lat1 - lat2)
    delta_lon = math.fabs(lon1 - lon2)
    return math.sqrt(math.pow(delta_lat * m_per_deg_lat, 2) + math.pow(delta_lon * m_per_deg_lon, 2))


def distance_between_locations(locations, avg_coords):
    ##generates a dictionary where the keys are locations and the values are lists that contain the name of other locations and the metric distance between this location and the key location
    distances = dict()
    for location in locations.keys():
        dist_from_loc = list()
        for other_location in locations.keys():
            if other_location != location:
                dist_from_loc.append(other_location)
                dist_from_loc.append(coords_to_metric(avg_coords[location][0], avg_coords[location][1], avg_coords[other_location][0], avg_coords[other_location][1]))
        distances[location] = dist_from_loc
    return distances


def tower_distances_from_gps_data(gps_data, cell_coords, city_distances, city_data):
    ##get the distances of all towers from gps_data and return a dictionary where an index of the person is the key of the distances
    ##dictionary and the value is the ten closest towers to them (the number of towers can be changed by adding more values to closest_towers)
    distances = dict()
    index = 0
    closest_cities_dict = dict()
    for person in gps_data:
        if person[5] not in closest_cities_dict.keys():
            closest_cities = [[" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")]]
            for city in city_distances.keys():
                if city.lower() == person[5].lower():
                    cities = city_distances[city]
                    for x in range(0, len(cities) - 1):
                        dist = cities[x + 1]
                        for y in range(0, 5):
                            if dist < closest_cities[y][1]:
                                closest_cities[y] = [cities[x], cities[x + 1]]
                                break
                        x += 1
            closest_cities_dict[person[5]] = closest_cities
        closest_cities = closest_cities_dict[person[5]]
        closest_towers = [[" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")], [" ", float("inf")]]
        try:
            all_available_towers = city_data[person[5].lower()][3]
        except ValueError:
            continue
        for x in range(0, len(closest_cities)):
            all_available_towers.append(city_data[closest_cities[x][0]][3])
        for cell in cell_coords.keys():
            if cell in all_available_towers:
                for x in range(0, 10):
                    dist = coords_to_metric(float(person[0]), float(person[1]), float(cell_coords[cell][0]), float(cell_coords[cell][1]))
                    if dist < closest_towers[x][1]:
                        closest_towers[x] = [cell, dist]
                        break
        distances[index] = closest_towers
        index += 1
    return distances


def total_towers_within_range(gps_data, cell_coords):
    ##return a dictionary of all towers within a certain range to each person where the index of the person is the key and the value is the list of towers
    towers = dict()
    index = 0
    for person in gps_data:
        count = 0
        for cell in cell_coords:
            dist = coords_to_metric(float(person[0]), float(person[1]), float(cell_coords[cell][0]), float(cell_coords[cell][1]))
            if dist <= 10000:
                count += 1
        towers[index] = count
        index += 1
    return towers


def write_dict_to_file(data, file_name):
    with open(file_name, "w") as file:
        file.write(pickle.dumps(data))


def main():
    cell_data = open_csv("data\\cells.csv")
    cell_data = clean_cell_data(cell_data)
    state_data = get_state_data(cell_data)
    city_data = get_city_data(cell_data)
    cell_dict = make_cell_data_dict(cell_data)
    cell_coords = get_cell_coords(cell_dict)
    avg_state_coords = get_avg_coords(state_data)
    avg_city_coords = get_avg_coords(city_data)
    #closest_state, closest_state_coords = get_closest_location(avg_state_coords)
    #closest_city, closest_city_coords = get_closest_location(avg_city_coords)
    state_distances = distance_between_locations(state_data, avg_state_coords)
    city_distances = distance_between_locations(city_data, avg_city_coords)
    gps_data = open_csv("data\\gps_data.csv")
    gps_data = clean_gps_data(gps_data)
    #tower_distances = tower_distances_from_gps_data(gps_data, cell_coords, city_distances, city_data)
    towers_range_data = total_towers_within_range(gps_data, cell_coords)
    write_dict_to_file(towers_range_data, 'total_towers_within_range.txt')


main()
