<h2>Networks of Guatemala: Commuting</h2>

#Summary
Given a set of call detail records (CDR) from a major Guatemalan telecom provider, this project categorizes callers into weekday commuters and weekend commuters. If x,y coordinates of cell towers are used, home and work locations can be approximated. Once mapped, this data can be compared with existing data such as regional economics and other interesting data. 
**Hyphothesis:** _weekend commuters earn a lower salary than weekday commuters_ 

#Definitions:
- **schoolHours:** 7am-2pm inclusive
- **workHours:** 7am-5pm inclusive
- **commuter:** a person who travels between two locations 5 times per week
- **workCommuter:** a commuter who resides at one location during non-workHours and resides in another location during workHours
- **studentCommuter:** a commuter who resides at location during non-workHours and resides in another location during schoolHours
- **nonCommuter:** a person who spends most of their time at one location
- **lunch:** the typical lunch time during which a commuter might make a phone call 
- **area studied:** the area enclosed in the x,y coordinates of towers (coverage map)
- **weekday:** monday-friday (inclusive)
- **weekend:** saturday and sunday
- **homeTower:** the tower used most frequently during non-work times
- **awayTower:** the tower used most frequently during work/school times

#Assumptions:
- workday is 7am-5pm
- schoolday is 7am-2pm
- one month is sufficient to generalize a person's home/work routine
- since these CDR are from a major telecom provider in Guatemala, this is
  sufficient to generalize
- if awayTower is x distance from homeTower, it is

#Things to classify
- **date:** weekday or weekend
- **commuter:** true or false if (away from home during workHours) commuter = true; else false
- **studentCommuter:** true or false if (away from home schoolHours and homeTower is close to awayTower) student = true; else false
- **workCommuter:** true or false 
- **nonCommuter:** true or false

#Questions
- classify into weekday/weekend, or better to count work hours?
- need to exclude students with cell phones who commute to school
- how to handle overnight workers? 
- since typical phone plans do not offer unlimited data, apps such as
  whatsapp are very common for both calling and texting. (Most major telecom
providers include unlimited whatsapp use.) How do we account
for this?

