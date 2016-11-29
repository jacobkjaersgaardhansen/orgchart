# Interactive organizational chart
This project aims to turn plain flat file organizational data into an easy and accessible overview of a complex organization. The project consists of these files and makes heavy use of <a href="https://d3js.org/">D3.js</a>.

### data_departments.csv
Contains raw data about the organization in tabular form. Each department is linked to its parent department by the 'Parent Org ID' and 'Org ID' values. 

### data_employees.csv
Contains raw data about the employees in tabular form. Each employee is linked to his/her department by the 'Rec ID' value.

### generator.ps1
Reads the data in 'data.csv' and turns it into a hierarchy in a format that is compatible with D3.js. The resulting hierarchy is stored in 'hierarchy.js'. 

### hierarchy.js
Contains the hierarchy generated by 'generator.ps1'.

### layout.htm
Contains formatting, style and the actual D3.js code, which presents the organizational chart based on the information in 'hierarchy.js'.
