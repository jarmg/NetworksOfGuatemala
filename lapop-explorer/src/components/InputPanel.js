import React, { Component } from 'react'
import PropTypes from 'prop-types';
import Select from 'react-select';

import { getData } from '../data/data';
import { ButtonGroup, Button, ExpandableSelect } from './Input';
import { inputText } from '../copy'


const question = {
  display: 'flex',
  justifyContent: 'space-between',
  marginTop: '10px',
  flexDirection: 'row',
}


export class InputPanel extends Component {
  constructor() {
    super()
  }

  inputPanel = () => {
    return {
      display: 'flex',
      flexDirection: 'column',
      padding: '10px',
      margin: '0 auto',
      flexBasis: '450px',
      height: 'fit-content',
      marginBottom: '10px',
      borderRadius: '7px',
      flexGrow:'2'
    }
  }

  copy = () => inputText(this.props.lang)

  chart = () =>
          <div name='chart' style={question}>
            <text> { this.copy().output }: </text>
            <ButtonGroup onChange={this.props.setView} value={ this.props.view }>
              <Button value={'scatter'}> 
                { this.copy().scatter }
              </Button>
              <Button value={'map'}> 
                { this.copy().map }
              </Button>
              <Button value={'stats'}>
                {this.copy().stats }
              </Button>
            </ButtonGroup>
          </div>

  year = () =>  
          <div name='year' style={question}>
            <text> { this.copy().year }: </text>
              <ButtonGroup onChange={this.props.setYear} value={ this.props.year }>
                <Button value={2014}> 2014 </Button>
                <Button value={2017}> 2017 </Button>
            </ButtonGroup>
          </div>


  selectVar = (label, onChange, multi, currVal) => () => {
    const options = Object.keys(this.props.vars).map(key => { 
                  return {
                    value: this.props.vars[key].code, 
                    label: this.props.vars[key].label 
                  }
                })

    const customStyles = {
      container: (base, state) => ({
        ...base,
        color: 'black',

      }),

      control: (base, state) => ({
        ...base,
        minWidth: '175px',
        maxWidth: '250px',
        borderRadius: '2px',
        minHeight: '10px',
      }),

      dropdownIndicator: (base, state) => ({
        ...base,
        padding: '2px 8px',
      }),

      valueContainer: (base, state) => ({
        ...base,
        padding: '1px 8px',
        overflowX: 'hidden',
      }),
      multiValue: (base, state) => ({
        ...base,
        overflowX: 'hidden',
        background: '#79b8fb',
        padding: '1px',
        whiteSpace: 'pre-line',
        margin: '2px 0px',
      }),
      multiValueLabel: (base, state) => ({
        ...base,
        overflowX: 'hidden',
        padding: '1px',
        color: 'white',
        paddingLeft: '2px',
        whiteSpace: 'pre-line',
        margin: '2px 0px',
      })
    }

    return <div style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    marginTop: '5px'}}> 
              <text> { label } </text>
              <Select 
                styles={customStyles}
                options={options} 
                onChange={ onChange } 
                isMulti={ multi }
                value={currVal} 
              />
            </div>
  }



  unit = () => 
          <div name='unit' style={question}>
            <text> {this.copy().unit}: </text>
            <ButtonGroup onChange={this.props.setUnit} value={ this.props.unit }>
              <Button value={'departamento'}> Dept </Button>
              <Button value={'municipio'}> Muni </Button>
            </ButtonGroup>
          </div>

    configs = () => {
      return {
        map: [
          this.selectVar(this.copy().variable + ':', this.props.setIndepVar, false, this.props.indepVar),
          this.year, 
          this.unit, 
        ],
        scatter: [
          this.selectVar('X variable', this.props.setIndepVar, false, this.props.indepVar),
          this.selectVar('Y variable', this.props.setDepVar, false, this.props.depVar), 
          this.year, 
          this.unit, 
        ],
        stats: [
          this.selectVar(
            this.copy().depVar + ':', 
            this.props.setDepVar, 
            false, 
            {label: this.props.depVar.label}
          ), 
          this.selectVar(
            this.copy().indepVar + ':', 
            this.props.setExogVars, 
            true, 
            Object.values(this.props.exogVars).map(v => {return {label: v.label, value: v.code}})
          ), 
          this.year, 
          this.unit, 
        ],
      }
    }
      
  render() {
    return(
      <div name='inputPanel' style={this.inputPanel()}>
        
        <text style={{margin: '-38px 0px 7px 0px'}}> { this.copy().view }</text>
        <div name='view' style={{padding: '10px', margin: '5px', boxShadow: '#007cff 0px 0px 3px', borderRadius: '4px'}}>
          {this.chart()}
        </div>

        <text style={{margin: '10px 0px 7px 0px'}}> { this.copy().config } </text>
        <div name='config' style={{padding: '10px', margin: '5px',  boxShadow: '#007cff 0px 0px 3px', borderRadius: '4px'}}>
          {this.configs()[this.props.view].map(input => input())}
        </div>

      </div>
    )
  }
}

InputPanel.propTypes = {
  setDepVar: PropTypes.func.isRequired,
  setIndepVar: PropTypes.func.isRequired,
  setYear: PropTypes.func.isRequired,
  setView: PropTypes.func.isRequired,
  setUnit: PropTypes.func.isRequired,
}
