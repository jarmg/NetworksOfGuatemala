# source (2014 GT LAPOP survey): http://datasets.americasbarometer.org/database/files/817947147LAPOPGua14-v15.2.5.1-Spa-140327_W.pdf

import pandas as pd


data_files = {
  '2014': 'data/lapop_2014.dta',
  '2017': 'data/lapop_2017.dta'
}


def _muni_to_prov(code):
  '''Parses the department coding from the muni coding'''
  sc = str(code)
  return int(sc[0] + sc[2] + sc[3])


def _clean_file(path, new_path):
  '''Makes stata file compatible with pandas by 
     making municipality names unique. Only run when database
     is first downloaded'''
  from pandas.io.stata import StataReader, StataWriter

  with StataReader(path) as sr:
    # Get data as stata file
    labels = sr.value_labels() 
    provs = labels['prov_eng'] #NOTE: 2014 uses _esp and 2017 uses _eng
    munis = labels['municipio_eng']

    # Append department names to munis
    labels['municipio_eng'] = {
      code: ('{}, {}').format(muni, provs.get(_muni_to_prov(code))) 
      for code, muni in munis.items() 
    }


    sr.value_label_dict = labels
    StataWriter(new_path, sr.read()).write_file()
    
  return None


def _normal_cleaning(data, code, reorder=True):
  print(("Cleaning {} - dropping {} rows due to NaNs").format(
      code, ( len(data[code]) - len(data[code].dropna()) ))
  )
  if reorder:
    data[code] = data[code].cat.reorder_categories (
      list(reversed(data[code].cat.categories)), ordered=True)

  data[code] = data[code].dropna().cat.codes # categorical to numeric
  return data 


def _clean_pol1(data):
  '''LAPOP POL1 2014 - How much do you care about politics'''
  code = 'pol1'
  return _normal_cleaning(data, code) 


def _clean_www1(data):
  '''LAPOP POL1 2014 - How frequently do you use the internet?'''
  code = 'www1'
  return _normal_cleaning(data, code) 


def _clean_indig(data):
  '''LAPOP POL1 2014 - New column that marks 1 if indigenous and 0 if not'''
  #NOTE: THIS REQUIRES ETID CLEANING TO ALREADY HAVE BEEN RUN

  base_code = 'etid'
  new_code = 'indig'

  data[new_code] = [1 if val==1 else 0 for val in data[base_code]]
  return data


def _clean_eff2(data):
  '''LAPOP POL1 2014 - You feel you understand the most important political issues facing the country?'''
  code = 'eff2'
  return _normal_cleaning(data, code) 


def _clean_etid(data):
  '''LAPOP POL1 2014 - Do you consider yourself ladino, indigenous, or other?'''
  code = 'etid'
  return _normal_cleaning(data, code, reorder=False) 


def _clean_prot3(data):
  '''LAPOP POL1 2014 - In the last 12 months, have you participated 
  in a demonstration or protest?'''
  code = 'prot3'
  return _normal_cleaning(data, code) 


def _clean_guaprot1(data):
  '''LAPOP POL1 2014 - Did you participate in the 2015 protests?''' 
  code = 'guaprot1'
  return _normal_cleaning(data, code) 


def clean(data, grouping=None):
  if (grouping) and (grouping != 'municipio') and (grouping != 'prov'):
    raise(ValueError(("grouping must be municipio or prov, not {}").format(grouping)))

  data = _clean_www1(data)
  data = _clean_pol1(data)
  data = _clean_etid(data)
  data = _clean_indig(data)
  data = _clean_prot3(data)
  data = _clean_eff2(data)
  #data = _clean_guaprot1(data)

  if grouping:
    data =  data.groupby(grouping, as_index=False).mean().reset_index()
  return data


def load(path):
  '''Accepts path to stata file and returns full pandas table'''
  data = pd.read_stata(path) 
  return data


def get_data(grouping=None, year='2017'):
  '''Accepts optional parameters grouping and year.
      - loads, cleans, and returns data
  '''
  df = data_files[year] 
  data = load(df)
  return clean(data, grouping)

if __name__ == '__main__':
  main()
