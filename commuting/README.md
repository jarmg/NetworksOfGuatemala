<h2>Networks of Guatemala: Commuting</h2>

## Summary
Given a set of call detail records (CDR) from a major Guatemalan telecom provider, 
this script finds the most probable home and work locations for each caller. 
The filtering is based on time of day and frequency of calls via a given cell tower. 
Since we have latitude/longitude coordinates of each cell tower, we 
estimate their work commute by using the GoogleMaps API to calculate driving
distance. (This is driving distance -- not displacement.)

## Data needed for analyses
- A large set of call detail records from a major Guatemalan telecom provider
- Tower data with a unique identifier and latitutde/longitude coordinates
  for each tower.

## Usage
There are two functions which need to be edited prior to running:
- **set_options()**: Use this to set the three constant values to be used throughout
  the analyses. The data frame which stores the set of constants is called
  k\_options.
  -  k\_work\_start\_time <- 8 # work start time is set to 8am by default.
  -  k\_work\_end\_time <- 18 # work end time is set to 6pm by default.
  -  k\_home\_id\_type <- 2 # home id type is set to 2 (municipality) by
     default. Other options:
    -  1: CELL\_ID (the unique identifier for cell towers)
    -  2: Department  
- **init_paths()**: Initialize all paths to csv data sets here.

Open an R interactive terminal and type 
`x <- main\_commute()`
There are some functions which can be uncommented and returned depending on
which analysis you want `x` to show.

## Unit Testing
There are currently only two functions to be tested in `test_commuter.r`.
Going forward, whenever debugging is needed (typing something into a
`print()` statement, etc), create a tester function in this file instead.
TODO: Use a dummy csv set to import to data frame to ensure same type.
I think current values might be of a different type (factors vs chars etc).

**Current Usage** (TODO: write an easy-to-run script which does all this)
- `cd` to `NetworksOfGuatemala/commuting/src/`<br>
- Open an R interactive terminal (type `R`)<br>
- If `testthat` is not installed, type `install.packages("testthat")<br>
- `library(testthat)`<br>
- test_dir(".")<br>
- Test results will be displayed in terminal<br>

# Assumptions:
- Work hours are k\_work\_start\_time until k\_work\_end\_time.
- Home hours are non work hours.
- One month is sufficient to generalize a person's home/work routine

## TODO (future functionality):
- There are many functions in the source code which say "IN PROGRESS" above
  the function. These may be useful to refine filtering.
- There are some functions which might not be needed (perhaps we can use one
  general label function instead of separate functions to deal with home and
work data). These are labeled with a question in the comment above the
function.
