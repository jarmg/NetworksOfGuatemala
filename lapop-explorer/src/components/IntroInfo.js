import React, { Component } from 'react'
import PropTypes from 'prop-types';
import { introText } from '../copy';

const intro = {
  display: 'flex',
  flexDirection: 'column',
  padding: '10px',
  margin: '0 auto 50px auto',
  height: 'fit-content',
  flexGrow:'1',
  background: '#ffffff0d',
  borderRadius: '5px',
  color: '#3a3939',
  background: 'rgba(255, 255, 255, 0.65)',
}


class Section extends Component {
  constructor(props){
    super(props)
    this.state = {
      expanded: this.props.expanded,
      hovered: false 
    }
  }

  introDiv = () => {
    return {
      borderBottom: '1px solid #a4a4a45e',
      marginBottom: '15px',
    }
  }

  title = () => {
    return {
      margin: '1px',
      color: this.state.hovered ? '#656464' : '#9e8f8f'
      
    }
  }

  expandedText = () => {
    return {
      fontSize: 'smaller',
      color: '#615d5d',
      padding: '10px',
      background: '#e5e5ffa6',
    }
  }

  arrow = () => {
    return {
      float: 'right',
      fontSize: 'x-large',
      cursor: 'pointer',
    }
  }

  handleClick = () =>
    this.setState( (prevState, props) => {
      return {
        expanded: !prevState.expanded
      }
    })

  handleHover = () =>
    this.setState( (prevState, props) => {
      return {
        hovered: !prevState.hovered
      }
    })

  render() {
    return (
      <div>
        <div name='intro_section' style={this.introDiv()}>
          <div 
            onClick = { this.handleClick } 
	    onMouseOver = { this.handleHover }
	    onMouseOut = { this.handleHover }
            style={{display: 'flex', justifyContent: 'space-between', cursor: 'pointer'}}
          >
            <text style={ this.title() }> 
              { this.props.title } 
            </text>
            { this.state.expanded ? 
              <text style={ this.arrow() }> ⌃ </text> : 
              <text style={ this.arrow() }> ⌄  </text> 
            }
    	  </div>

            { this.state.expanded &&
                 <div style = { this.expandedText() }>
                  { this.props.text }
                 </div>

            }
          </div>
      </div>
  )}
}


const IntroInfo = props =>  
       <div name='introPanel' style={ intro }>
          {Object.keys(introText(props.lang)).map( (key, idx) => 
            <Section 
              title={ key } 
              text={ introText(props.lang)[key] }
              expanded={ !idx }
            />)
          }
        </div>

  export default IntroInfo;
