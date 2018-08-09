from scipy.spatial import Voronoi, voronoi_plot_2d
import matplotlib.pyplot as plt
import numpy as np
import shapefile as shp

lat_lon = np.load(open('lat_lon.npy','rb'))
vor = Voronoi(lat_lon)
voronoi_plot_2d(vor)

sf = shp.Reader("C:\\Users\\alexa\\Desktop\\Guatemala_Data\\voronoi\\GTM_adm\\GTM_adm2.shp")
plt.figure()
for shape in sf.shapeRecords():
    x = [i[0] for i in shape.shape.points[:]]
    y = [i[1] for i in shape.shape.points[:]]
    plt.plot(x, y)
plt.show()
