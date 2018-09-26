import React, { Component } from 'react';
import { infoBoxText } from '../copy.js';

const collapsed = {
  boxShadow: '4px 4px 32px -13px black',
  margin: '10px',
  paddingLeft: '4px',
  paddingRight: '4px',
  width: 'fit-content',
  position: 'absolute',
  background: '#797575d9',
  color: 'white',
  fontSize: '12px',
}

const expanded = {
  background: '#6c6262fa',
  bottom: '0',
  boxShadow: '4px 4px 32px -13px black',
  boxSizing: 'border-box',
  color: 'white',
  display: 'grid',
  fontSize: '12px',
  gridTemplateColumns: '35% 65%',
  gridTemplateRows: '10% 85%',
  left: '0',
  margin: '10px',
  paddingLeft: '4px',
  paddingRight: '4px',
  position: 'absolute',
  right: '0',
  top: '0',
  zIndex: '2',
  gridTemplateAreas: ` 
                      "top top"
                      "bottom bottom" `
}

const closeButton = {
  background: 'none',
  border: 'none',
  color: '#e6e6e6',
  fontSize: 'medium',
  position: 'absolute',
  right: '1%',
  top: '1.5%',
  cursor: 'pointer',
}


class ExpandedInfoBox extends Component {


  render() {
    const data = this.props.data.data
    const dept = this.props.data.NAME_1
    const muni = this.props.data.NAME_2
    const variable = this.props.variable
    const value = data[variable.code]
    const vars = this.props.vars
  
    return(
      <div style={ expanded }> 
        <p style={{gridArea: 'top', borderBottom: '1px solid white' }}> 
      	  <button style={closeButton}>  x  </button> 
          <span style={{margin: '5px', marginRight:'15px'}}> 
            <b> { infoBoxText(this.props.lang).dept }: </b> { dept } 
          </span>
          { muni && 
            <span> 
              <b> { infoBoxText(this.props.lang).muni }: </b> { muni } 
            </span>
          }
        </p>
        <div style={{height: '100%', gridArea: 'bottom', overflow: 'auto',}}>
          { value ?
            <span> {Object.keys(vars).map(key => 
                <p style={{ padding: '7px', borderBottom:'1px solid #ffffff40'}}> 
                  <span> { vars[key].label } </span> 
                  <span style={{float: 'right'}}> 
                    { (data[key] * 1).toFixed(2) } out of { vars[key].high }
                  </span>
                </p>)} 
            </span>
            : <span> { infoBoxText(this.props.lang).noData } </span>
          }
        </div>
      </div>
    )
  }
}


class CollapsedInfoBox extends Component {

  render() {
    const dept = this.props.data.NAME_1
    const muni = this.props.data.NAME_2
    const data = this.props.data.data
    const variable = this.props.variable
    const value = data[variable.code]
    const vars = this.props.vars
    const lang = this.props.lang

    return(
      <div style={ collapsed }>
        <p> <b> { infoBoxText(lang).dept }: </b> { dept } </p>
        { muni && <p> <b> { infoBoxText(lang).muni }: </b> { muni } </p> }
        { value ? 
            <p> { variable.label } : { value.toFixed(2) } out of { variable.high } </p>
            : <p> { infoBoxText(lang).noData }</p>}
      </div>
    )
  }
}



class InfoBox extends Component {
  constructor(props) {
    super(props)
    this.state = {
      expanded: this.props.expanded
    }
  }

  static getDerivedStateFromProps = (nextProps, prevState) => {
    return {expanded: nextProps.expanded}
  }

  render(){
    return(
      <div onClick={ this.props.collapse }>
        { this.state.expanded ? 
          <ExpandedInfoBox {...this.props}/>
          : <CollapsedInfoBox {...this.props}/>} 
      </div>
    
    )
  }
}


export default InfoBox;
