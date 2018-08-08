**remittance_data.csv**
- takes the relevant data from the 2014 ENCOVI survey regarding international remittances, household identification numbers, and the department of each survey taker so as to decrease the size of the database being used and to make the data easier to navigate through

**ENCOVI_translation_of_variable_names.csv**
- contains the name of all of the variables of the 2014 ENCOVI survey in Spanish in the first column and the English translation of the variables in the second column

**ENCOVI_variables_spanish.xlsx**
- a file provided by the Instituto Nacional de Estadistica Guatemala that states what each variable code means in the 2014 ENCOVI survey and what each answer code means

**data_cleanup.py**
- cleans up the data in remittance_data.csv by making a list of all households that answered that they do receive international remittances, there is also some analysis and extrapolation of the data in one of the functions in this file so as to get a cursory idea of what the remittance statistics are approximately in each department

**extrapolation_info.txt**
- explains where the factor used for extrapolating the data in data_cleanup.py comes from
