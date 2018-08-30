**comparing_towers.py**
- Requirements:
  - open_cell_id.csv
    - Available in the data folder
  - Cells.csv
  - File locations will need to be updated
- Purpose:
  - Compares Tigo data from Cells.csv (file location in program needs to be changed) to the data from open_cell_id.csv (file location needs to be changed)
- Current Functionality:
  - Opens and cleans relevant data to be used for comparing towers between Tigo and Open Cell ID
  - Gets all cells in each area from the Open Cell ID data and organizes them by technology 
    - This is organized as a dictionary where the keys are the area values and the values are dictionaries that contain the technology (either GSM, LTE, or UMTS) as the key and a list of all cells in that area using that technology as the value 
  - Gets all cells from the Open Cell ID data that are also in the Tigo data and organizes them in a manner similar to the dictionary described above
- Planned Functionality: 
  - Compare the dictionaries above to determine how many towers are shared between the two datasets and determine if there are patterns in the towers that are in the Open Cell ID data but not in the Tigo data
  - Use the data from comparing the towers to determine the possible range of each tower based on the technology in the towers
    - The function for determining tower range has been written and is ready to be implemented (the get_distance function which relies on the get_signal_loss function)
    - The commented out compare_data function implements the above function to determine towers that match each other between each dataset, however, this function was written before the Tigo cell_ids were figured out, thus it needs to change to account for that


**data_analysis_gem.py**
- Requirements:
  - AST 0.0.2
  - numpy 1.15.0
  - pandas 0.23.4
  - statsmodels 0.9.0
  - total_towers_within_range.txt
    - Generated from network_analysis.py
  - gem_data.csv
    - Useful data from the GEM survey data (a SAV file) saved to a CSV file for easy use in Python
- Purpose:
  - With the data from the GEM survey, model variables against each other with any of LSR, GLS, GLSAR, QuantReg, Logit, or Probit regression
- Current Functionality:
  - Opens and cleans GEM data including converting any codes needed, flagging data, and applying log functions if desired
  - Applies regression onto inputed predictor and response variables
- Planned Functionality:
  - Add a return value to the stats function so that it returns the predictor for the model
    - With this, a function can be added that combines the various different regression techniques into a stacked regression model
  - Expand the model by accounting for network performance with the tower data from comparing_towers.py


**dta_prep.py**
- Requirements:
  - lapop_2014.dta
    - Available in the data folder
  - lapop_2017.dta
    - Available in the data folder
- Purpose:
  - Clean lapop dta files and make them easily readable in Python
  - Current Functionality:
  - This program is from the lapop_explorer and has not been modified, thus it has the same functionality as that program
- Planned Functionality:
  - If needed, use the lapop dta files with this, however, the lapop data that seems useful has been saved into a csv file and is easily readable in Python as it is


**income_vs_tower_frequency.py**
- Requirements:
  - Same as data_analysis_gem.py except for of matplotlib 2.2.3 which is required for this program
- Purpose:
  - This is an older, less modular, and messier version of data_analysis_gem.py
  - This program is here as reference and has no current purpose as it has been outdated by the improved data_analysis_gem.py
- Current Functionality:
  - N/A
- Planned Functionality:
  - N/A


**network_analysis.py**
- Requirements:
  - gps_data.csv
    - The gps_data.csv file can be changed to using the gem_data.csv file if desired, however, only the columns relevant for location need to be used
  - cells.csv
    - Tigo data
  - departments.csv
    - contains the codes for departments in one column and the department those codes represent in another column
  - municipalities.csv
    - contains the codes for municipalities in one column and the municipalities those codes represent in anotheer column
  - All file locations need to be updated
- Purpose:
  - Calculates how many towers are within a certain range of those who responded to the GEM survey (total_towers_within_range function) and writes to the file total_towers_within_range.txt
  - Calculates the closest n towers to those who responded to the GEM survey (tower_distances_from_gps_data function)
- Current Functionality:
  - Cleans Tigo and GEM GPS data to be usable
  - With the get_closest_location function, gets the approximate closest department/state, municipality/city, or tower to an inputed latitude longitude pair
  - With the distance_between_locations function, a dictionary where the keys are locations and the values are lists that contain a list with another location and the metric distance between the initial location and this location
- Planned Functionality:
  - N/A
