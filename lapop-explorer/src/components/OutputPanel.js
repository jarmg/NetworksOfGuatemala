import React, { Component } from 'react';
import { Button } from './Input';
import { ScatterChart } from './Scatter'
import { Map } from './Map'
import { StatsOutput } from './StatsOutput'
import { getData } from '../data/data';
import { ols } from '../stats';
import muni_map from '../data/muni_map.json';
import dept_map from '../data/dept_map.json';


const outputPanel = {
 backgroundColor: '#FFF',
 borderRadius: '3px',
 boxShadow: 'black 2px 2px 15px',
 boxSizing: 'border-box',
 color: '#313131',
 flexBasis: '400px',
 flexGrow: '1',
 margin: '0 auto',
 padding: '10px',
 position: 'relative',
}


const mapData = (unit, year, variable) => {
  return {
    geoData: geoData(unit),
    variable: variable,
    disabled: variable == undefined,
  }
}


const statsData = (depVar, exogVars, data) => {
  if( depVar == undefined || exogVars.length < 2)
    return({disabled: true})

  let indeps = Object.values(data[exogVars[0].code]).map((dt, idx) => 
    exogVars.map(exogVar => data[exogVar.code][idx]))

  const deps = Object.values(data[depVar.code])
  let output = ols(deps, indeps)
  return({
    output: output,
    exogVars: exogVars,
    endogVar: depVar
  })
}


const geoData = (unit) => {
  switch(unit){
    case 'departamento':
      return dept_map
      break;
    case 'municipio':
      return muni_map
      break;
    default:
      throw "Invalid geographic unit"
  }
}


const scatterData = (unit, indepVar, depVar, data) => {
  let labels = []
  if (unit == 'departamento')
    labels = Object.values(data.prov)
  if (unit == 'municipio')
    labels = Object.values(data.municipio)

  return {
    indepVar: indepVar,
    depVar: depVar,
    labels: labels,
    data: data,
    disabled: (depVar == undefined || indepVar == undefined)
  }
}


export class OutputPanel extends Component {
  constructor(props) {
    super(props)
    this.state = {
      year: props.year,
      unit: props.unit,
      data: getData(props.unit, props.year)
      }
  }

  static getDerivedStateFromProps = (nxtProps, curState) => {
    if(nxtProps.year == curState.year && nxtProps.unit == curState.unit)
      return
    else
      return {
        year: nxtProps.year,
        unit: nxtProps.unit,
        data: getData(nxtProps.unit, nxtProps.year)
      }
  }



  render() {
    return(
      <div style={outputPanel}>
        { this.props.view == 'map' && 
          <Map 
            {...mapData(this.props.unit, 
                  this.props.year, 
                  this.props.indepVar)}
            vars={ this.props.vars }
            data={ this.state.data }
            lang={ this.props.lang }
          />
        }

        { this.props.view == 'scatter' && 
          <ScatterChart 
            {...scatterData(this.props.unit,
                  this.props.depVar,
                  this.props.indepVar,
                  this.state.data)}
          />
        }

        { this.props.view == 'stats' &&
          <StatsOutput 
            {...statsData(this.props.depVar, 
                  this.props.exogVars,
                  this.state.data)}
            lang={ this.props.lang }
          />
        }

      </div>
    )
  }
}

