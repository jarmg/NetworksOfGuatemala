import React, { Component } from 'react';
import { statsText } from '../copy.js';


const output = {
  marginLeft: '10px', 
  fontFamily:'monospace'
} 

const outputSect= {
  fontSize: 'small', 
}


export class StatsOutput extends Component {
  constructor() {
    super()
  }

	render() {
    if(this.props.disabled)                 
      return(                                    
        <div>                                                             
          <h1 style={{margin: '15%', textAlign: 'center'}}>    
            { statsText(this.props.lang).varsRequired }
          </h1>                                                           
        </div>)   
		return(
			<div style={{backgroundColor:'white'}}>
        <h3 style={{
              borderBottom: '1px solid grey', 
              paddingBottom: '5px', 
              margin:'0'
        }}> 
          { statsText(this.props.lang).olsTitle }
        </h3>
        <br />
        <b> { statsText(this.props.lang).modelInfo }: </b>
        <br />
        <p style={outputSect}> { statsText(this.props.lang).depVar }:
          <ul style={output}>
            <li> { this.props.endogVar.label } </li>
          </ul>
        </p>
        <p style={outputSect}> { statsText(this.props.lang).indepVar }:
          <ul>
            { this.props.exogVars.map((xVar, idx) => 
                <li style={output}> {xVar.label} </li>)
            } 
          </ul>
        </p> 

        <br />
        <br />

        <b> { statsText(this.props.lang).analysis }: </b>
        <p style={outputSect}> { statsText(this.props.lang).rSquared }:
          <ul>
            <li style={output}> 
              {this.props.output.R2.toFixed(3)} 
            </li>
          </ul>
        </p>  
        <p style={outputSect}> { statsText(this.props.lang).coefs }:
          <ul>
            { this.props.output.coef.map((coef, idx) =>
                <li style={output}> 
                  {coef.toFixed(2)} ({this.props.exogVars[idx].label}) 
                </li>)
            }
          </ul>
        </p>  
			</div>
		)
	}
}

