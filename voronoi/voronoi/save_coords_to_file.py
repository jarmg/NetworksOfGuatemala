import csv
import numpy as np
from numpy import array

with open("cells.csv") as f:
    reader = csv.reader(f)
    calls = list(reader)
calls = calls[1:]
lat_lon_list = list()
for call in calls:
    try:
        lat_lon_list.append((float(call[1]), float(call[2])))
    except ValueError:
        continue
array(lat_lon_list).dump(open('lat_lon.npy',  'wb'))
