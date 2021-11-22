# San Francisco Data Overview




## <ins> Preloaded data within USF package </ins> 


- `sf_parcels`: Parcels within the City (includes zoning)
- `ptaxdata_*`: Parcel tax data for each year from 2007 to 2021.
  *Add last two digits of years from 2007 to 2021
  Example: `ptaxdata_0708` for 2007/2008 tax year or `ptaxdata_1011` for 2010/2011
  tax year.
- `sf_pdistricts`: Current Police Districts
- `sf_pdcalls`: Calls for service to Police Department
- `sf_incident`: Police Department incident report from 2018 to present
- `CopMonitor`: Police misconduct database
- `sf_pdbudget`: SFPD Budget data for each Fiscal Year from 2007 to 2021
  SFPD Budget Data pulled from Annual Appropriations Ordinances for each year. They can be found [here](https://openbook.sfgov.org/webreports/search.aspx?searchString=&year=1986&year2=2021&type=CityBudgets&index=0&index2=3&index3=0)
  Columns 4-10 indicate revenue streams. Columns 13-19 indicate department spending.          
- `sf_pdstaff2007`: Staffing data for SFPD for 2020 and 2007. Unless specified (columns [7:8]), all columns refer to 2020 data.
  The largest expenditure for district offices is officer salaries, so using the number of staff members as a proxy should provide an idea of which districts receive the most funding.
  The table compiles the distribution of officers who are regularly "on the street" to get an idea of officer density
  For more info on SFPD reports, click [here](https://www.sanfranciscopolice.org/your-sfpd/published-reports)
- `sf_fedgrants`: Federal Grants awarded to San Francisco
  For more on federal funding, click [here](https://www.usaspending.gov/search/?hash=1bc27eda4fd1ca4ad84638d682e995cf)
  
  
## <ins> Dropbox data </ins>

 [Link to folder](https://www.dropbox.com/sh/jh6zs8667w2b9wz/AADup1H0hIQktDqFQ0JQwwyIa?dl=0)
 Unless specified, all shapefiles are in compressed format (.zip)
 
- `dd1033_CA`: Department of Defense 1033 Program for California
- metadata on `sf_pdcalls`, `sf_incident`, and `sf_parcels`
- metadata on `ptaxdata_*`

## <ins> Sources </ins>

- Open San Francisco
- San Francisco Assessor Office
- ACLU
- San Francisco Public Defender
- San Francisco Police Department
- National Police Funding Database


[Back to home](https://github.com/agroimpacts/USF#readme)
