import dept17 from './dept_2017.json';
import muni17 from './muni_2017.json';
import dept14 from './dept_2014.json';
import muni14 from './muni_2014.json';

const getDeptDataByLocation = (geoData, dataset) => {                                         
  const idx = Object.values(dataset['prov']).indexOf(geoData.NAME_1)   
  return Object.keys(dataset).reduce((data, key) => { 
      data[key] = dataset[key][idx] 
      return data}, {})
}

const getMuniDataByLocation = (geoData, dataset) => {
	const locale = ( geoData.NAME_2 + ', ' + geoData.NAME_1 )               
	const idx = Object.values(dataset['municipio']).indexOf(locale)
  return Object.keys(dataset).reduce((data, key) => { 
      data[key] = dataset[key][idx] 
      return data}, {})
}

export const getDataByLocation = (geoData, dataset) => {
  if(geoData.NAME_2) {
    return getMuniDataByLocation(geoData, dataset)
  } else {
    return getDeptDataByLocation(geoData, dataset)
  }
}

export const getData = (grouping, year) => {
    const error = "Invalid data selection: " + grouping + ' in ' + year
    let data = null
    if (grouping == 'municipio') {
      if(year == '2017')
        data = muni17
      else if(year == '2014')
        data = muni14
      else
        throw error
    } else if(grouping == 'departamento') {
        if(year == '2017')
          data = dept17
        else if(year == '2014')
          data = dept14
        else
          throw error
    } else
        throw error
    return JSON.parse(data)
  }
