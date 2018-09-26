import React, { Component } from 'react';


import { InputPanel } from './components/InputPanel';
import { OutputPanel } from './components/OutputPanel.js';
import IntroInfo from './components/IntroInfo.js';
import { getVars } from './data/varcoding.js';
import { title } from './copy';
import { ButtonGroup, Button } from './components/Input'; 


const section1 = {
  backgroundSize: 'cover',
  background: 'linear-gradient(to right bottom, #ffffff, #dbdbedcf',
  padding: '30px',
  minHeight: '100vh',
  boxSizing: 'border-box',
  color: '#19191a',
  padding: '15px',
  overflow: 'auto',
}

class App extends Component {
  constructor() {
    super()
    const lang = navigator.language.substr(0,2) == 'es' ? 'es' : 'en'
    this.state ={
      view: 'map',
      depVar: getVars('2017', lang)['pol1'], 
      indepVar: getVars('2017', lang)['indig'], 
      exogVars: [getVars('2017', lang )['www1'], getVars('2017', lang)['prot3']], 
      unit: 'departamento',
      year: '2017',
      vars: getVars('2017', lang),
      lang: lang,
  }
}

  resetInvalidVars = (year, lang) => {
    const vars = getVars(year, lang)
    this.setState({
      depVar: vars[this.state.depVar.code] || vars['pol1'],
      indepVar: vars[this.state.indepVar.code] || vars['www1'],
      exogVars: this.state.exogVars.map(val => vars[val.code] || vars['www1'])
    })
  }

  callbacks = () => {
    return {
      setDepVar: ({value}) =>
        this.setState({depVar: this.state.vars[value]}),
      setIndepVar: ({value}) =>
        this.setState({indepVar: this.state.vars[value]}),
      setView: view => 
        this.setState({ view: view }),
      setUnit: unit =>
        this.setState({ unit: unit }),
      setYear: year => {
        this.resetInvalidVars(year, this.state.lang)
        this.setState({ 
          year: year,
          vars: getVars(year, this.state.lang)
        })
      },
      setExogVars: exogVars => {
        this.setState({exogVars: exogVars.map(({value, label}) => this.state.vars[value])})
      },
      setLang: lang => {
        this.setState({
          lang: lang,
          vars: getVars(this.state.year, lang)
        })
        this.resetInvalidVars(this.state.year, lang)
      }
    }
  }

  render() {
    return(
      <div name='background' >
        <section name='section1' style={ section1 }>
				<div style={{display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', flexWrap: 'wrap'}}>
          <h2> { title(this.state.lang) } </h2>
					<ButtonGroup onChange={ this.callbacks().setLang } value={ this.state.lang }>         
						<Button value={'en'}> English </Button>                          
						<Button value={'es'}> Español </Button>                          
					</ButtonGroup>
				</div>
          <hr />
          <IntroInfo { ...this.state }/>
          <div style={{display: 'flex', flexWrap:'wrap'}}> 
            <InputPanel {...this.callbacks()} {...this.state} /> 
            <OutputPanel {...this.state}/> 
          </div>
        </section>
        <section name='section2'>
        </section>
      </div>


    )
  }
}

export default App;
