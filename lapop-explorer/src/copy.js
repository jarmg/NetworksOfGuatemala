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

          Welcome to the Networks of Guatemala Data Explorer! 

          <br /> <br />

          The NoG Data Explorer is used to perform basic data 
          visualization and analysis for population 
          information around Guatemala.

          <br /> <br />

          Get started by selecting a view below and then configuring the data output with
          different variables and data. 
        </text>
      </div>),
  'Data source': (
      <div>
        <text>
          The datasets that support the NoG Data Explorer come from
          The AmericasBarometer Survey which is run by the Latin American
          Public Opinion Project (LAPOP).

          <br /> <br />

          The AmericasBarometer is a scientifically rigorous comparative 
          survey that covers all of North, Central, and South America. 
          In the case of Guatemala, LAPOP has been running data collection 
          every two years since 1992. 

          <br /> <br /> 

          For more information regarding LAPOP or The AmericasBarometer <a 
              target='_blank' href='https://www.vanderbilt.edu/lapop/'> 
              visit their website 
          </a> where you can read more about the survey methodology
          and download the raw data that supports this application
        </text>
      </div>),
   'Who are we': (
      <div>
        <text>
          This application is part of an ongoing research project called 
          Networks of Guatemala investigating the impact that internet 
          performance has on political engagement in indigenous communities. 
          
          <br /> <br />

          The project is supported by Vint Cerf and
          The Marconi Society through an Internet and Democracy Research 
          Grant and is running from January 2018 to December 2018.

          <br /> <br />

          For more information take a look at 
          the <a target='_blank' href='http://www.NetworksOfGuatemala.com'>
                Networks of Guatemala Blog
              </a> or reach out to our PI, <a href='mailto:JaredGreene1@gmail.com'>
              Jared Greene</a>.
        </text>
      </div>)
  }
const introText_es = {
  'Esta aplicación': (
      <div>
        <text> 
          ¡Bienvenido a Networks of Guatemala Data Explorer!
          <br /> <br />
          NoG Data Explorer se utiliza para realizar una visualización y 
          análisis de datos básicos para la información de la población 
          arededor Guatemala.
          <br /> <br />
          Comience por seleccionar una vista y sus variables de 
          configuración en el panel a continuación. 
        </text>
      </div>),
  'Funte de datos': (
      <div>
        <text>
					
					Los conjuntos de datos que admiten NoG Data Explorer provienen 
					de la Encuesta del Barómetro de las Américas, que es ejecutada 
					por el Proyecto de Opinión Pública de América Latina (LAPOP).
          <br /> <br />
					El Barómetro de las Américas es una encuesta comparativa 
					científicamente rigurosa que cubre todo el Norte, Centro y 
					Sudamérica. En el caso de Guatemala, LAPOP ha estado ejecutando 
					la recolección de datos cada dos años desde 1992.
          <br /> <br />
					Para obtener más información sobre LAPOP o el Barómetro de las 
					Américas, <a
						target='_blank' href='https://www.vanderbilt.edu/lapop/'> 
							visite su sitio web 
					</a> donde puede leer más sobre la 
					metodología de la encuesta y descargar los datos brutos que 
					admiten esta aplicación.
        </text>
      </div>),
   'Quien somos?': (
      <div>
        <text>
					Esta aplicación es parte de un proyecto de investigación en 
					curso llamado Redes de Guatemala que investiga el impacto que 
					el rendimiento de Internet tiene en el compromiso político de 
					las comunidades indígenas.
          <br /> <br />
					El proyecto cuenta con el respaldo de Vint Cerf y The Marconi 
					Society a través de una subvención de investigación de Internet 
					y Democracia, y se realizará entre enero de 2018 y diciembre 
					de 2018.
          <br /> <br />
					Para obtener más información, eche un vistazo 
					al <a target='_blank' href='http://www.NetworksOfGuatemala.com'>
						Blog de Redes de Guatemala 
					</a> o comuníquese con nuestro Investigador Principal, <a
						href='mailto:JaredGreene1@gmail.com'>Jared Greene</a>.
        </text>
      </div>)
  }

