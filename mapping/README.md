<h2>Networks of Guatemala: Mapping</h2>

## Summary
Given a set of call detail records (CDR) from a major Guatemalan telecom provider, 
along with election data, this script uses the output from the commuting script to
create two matrices: one of voting patterns between municipality pairs and the 
other of call communication patterns between municipality pairs. The data
between the two matrices is combined into a paired list so that we can
observe the correlation between voting patterns and communication between
communities.

## Data needed for analyses
- All of the data needed for the commuting script, plus a csv of election
  data.

## Usage
There are two functions which need to be edited prior to running:
- **set_options()**: Use this to set the three constant values to be used throughout
  the analyses. The data frame which stores the set of constants is called
  k\_options.
  -  k\_work\_start\_time <- 8 # work start time is set to 8am by default.
  -  k\_work\_end\_time <- 18 # work end time is set to 6am by default.
  -  k\_home\_id_type <- 2 # home id type is set to 2 (municipality) by
     default. Other options:
    -  1: CELL\_ID (the unique identifier for cell towers)
    -  2: Department  
- **init_paths()**: Initialize all paths to csv data sets here.

Open an R interactive terminal and type x <- main\_mapping().
If x == 0, the script ran successfully.
After the script runs, there will be two csv files written to the current
working directory:
- **jvp\_mat.csv**: A matrix of joint voting patterns containing the voter
  similarity between two municipalities. Voter similarity, V, is calculated
by: V = 100 - |A\_1 - A\_2|, where A\_1 is the percentage of people from
muni1 who voted for a political party, and A\_2 is the percentage of people
from muni2 who voted for that same political party.

Open an interactive R terminal, and type:
**jvp <- read\_mat\_csv(1)**<br>
**comm <- read\_mat\_csv(2)**<br>
**jvp\_list <- make\_paired\_list\_from\_matrix(jvp)**<br>
**comm\_list <- make\_paired\_list\_from\_matrix(comm)**<br>
**jvp\_list <- append\_comm\_vals\_to\_jvp\_list(jvp\_list, comm\_list)**<br>
jvp\_list now contains all of the data and can be subsetted to generate
plots.


## TODO (future functionality):
- There are many functions in the source code which say "IN PROGRESS" above
  the function. These may be useful to refine filtering.
- There are some functions which might not be needed (perhaps we can use one
  general label function instead of separate functions to deal with home and
work data). These are labeled with a question in the comment above the
function.
