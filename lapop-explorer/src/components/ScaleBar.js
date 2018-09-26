import React, { Component } from 'react';

class ScaleBar extends Component {
  constructor() {
    super()
  }

  getColorGradient = () =>
    'linear-gradient(' + this.props.lowColor + ', ' 
      + this.props.highColor + ')'

  render() {
    return(
      <div 
        style={{
          width: '40px',
          height: '250px',
          position: 'absolute',
          margin: '10px',
          marginTop: '170px',}}
        >

        <p style={{transform: 'rotate(-90deg)'}}> Conentration of indigineous population </p>
        <div name='gradient bar' style={{
          width: '30px',
          height: '250px',
          display: 'inline-block',
          background:  this.getColorGradient(), 
          boxShadow: 'black 4px 4px 20px -3px',
        }}>
        </div>
      </div>
    )
  }
}

export default ScaleBar;
