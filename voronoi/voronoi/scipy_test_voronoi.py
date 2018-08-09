import scipy
from scipy.spatial import Voronoi, voronoi_plot_2d
import matplotlib.pyplot as plt
import numpy as np

points = np.array([[0, 0], [0, 1], [0, 2], [1,0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2], [3, 1], [3, 4], [3, 2]])
vor = Voronoi(points)
fog = voronoi_plot_2d(vor)
plt.show()
