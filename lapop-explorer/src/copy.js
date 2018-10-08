//Contains text for application - largest use case is language switching
import React from 'react';

export const title = lang => 
  lang == 'en' ? title_en : title_es

export const inputText = lang => 
  lang == 'en' ? inputText_en: inputText_es 

export const introText = lang => 
  lang == 'en' ? introText_en : introText_es

export const infoBoxText = (lang) => 
  (lang == 'en' ? infoBox_en : infoBox_es)

export const statsText = (lang) => 
  (lang == 'en' ? statsView_en : statsView_es)



/**********Title copy**********/
const title_en = 'Networks of Guatemala - Data Explorer'
const title_es = 'Networks of Guatemala - Explorador de Datos'



/**********Stats View copy**********/
const statsView_en = {
  olsTitle: "Ordinary Least Squared Analysis",
  depVar: "Dependent variable",
  indepVar: "Independent variables",
  analysis: "Analysis",
  rSquared: "R-squared",
  modelInfo: "Model information",
  coefs: "Coefficients",
  varsRequired: `Please select one dependent variable and two 
                  or more independent variables`
}
const statsView_es = {
  olsTitle: "Ordinary Least Squared Analysis",
  depVar: "Variable dependiente",
  indepVar: "Variables independiente",
  analysis: "Análisis",
  rSquared: "R-squared",
  modelInfo: "Información del modelo",
  coefs: "Coeficientes",
  varsRequired: `Elige un variable dependente y dos o más 
                  variables independente por favor`
}


/**********Info Box copy**********/
const infoBox_en = {
  dept: "State",
  muni: "Town",
  noData: "No surveys conducted in this area",
}
const infoBox_es = {
  dept: "Departamento",
  muni: "Municipalidad",
  noData: "No era ninguna colleción en esta lugar",
}


/**********Input Panel copy**********/
const inputText_en = {
  config: "Configuration",
  depVar:   "Dependent variable",
  indepVar: "Independent variable",
  map: "Map",
  output: "Output chart",
  scatter: "Scatter",
  stats: "Analysis",
  unit: "Unit",
  variable: "Variable",
  view: "View",
  year: "Year",
}

const inputText_es = {
  config: "Configuración",
  depVar: "Variable dependiente",
  indepVar: "Variables independiente",
  map: "Mapa",
  output: "Gráfico de salida",
  scatter: "Gráfico",
  stats: "Análisis",
  unit: "Unidad",
  variable: "Variable",
  view: "Vista",
  year: "Año",
}



/**********Intro Information copy**********/
const introText_en = {
  'About this application': (
      <div>
        <text> 

          Welcome to the Guatemala's Superintendence of Telecommunications Data Explorer! 

          <br /> <br />

          The SoT Data Explorer is used to perform basic data 
          visualization and analysis for population 
          information around Guatemala.

          <br /> <br />

          Get started by selecting a view below and then configuring the data output with
          different variables and data. 
        </text>
      </div>)
  }
const introText_es = {
  'Esta aplicación': (
      <div>
        <text> 
          ¡Bienvenido al Explorador de Datos de la  Superintendencia de Telecomunicaciones de Guatemala!
          <br /> <br />
          El Explorador de Datos de la STG se utiliza para realizar una visualización y 
          análisis de datos básicos para la información de la población 
          arededor de Guatemala.
          <br /> <br />
          Comience por seleccionar una vista y sus variables de 
          configuración en el panel a continuación. 
        </text>
      </div>)
  }

