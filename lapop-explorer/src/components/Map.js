import React, { Component } from 'react';

import { scaleLinear } from "d3-scale";
import { Button } from 'react-bootstrap';
import InfoBox from './InfoBox';
import { getDataByLocation } from '../data/data.js';

import {
  ComposableMap,
  ZoomableGroup,
  Geographies,
  Geography,
} from 'react-simple-maps'

const LOWCOLOR  = '#B6C4F9'
const MIDCOLOR  = '#6B8AFD'
const HIGHCOLOR = '#3357FF'

const zoomButtons = {
  display: 'flex',
  flexDirection: 'column',
  left: '-6%',
  top: '83%',
  height: '53px',
  width: 'fit-content',
  position: 'relative',
  boxShadow: 'black 1px 1px 3px',
  borderRadius: '2px',
  background: '#fbfafa',
}

const button = {
  background: 'none',
  border: 'none',
  padding: '4px 8px',

}

export class Map extends Component {
  constructor(props) {
    super(props)
    this.state = {
      zoom: 1,
      hovered: false,
      clicked: false,
      hoverData: {},
      data: null,
      forceUpdate: false,  
      width: window.innerWidth < 500 ? (0.8 * window.innerWidth) : 500,
      height: 400,
    }
  }

  componentWillReceiveProps = (nextProps) => {
    if (nextProps.variable != this.props.variable || nextProps.data != this.props.data){
      this.setState({
        forceUpdate: true,
      })
    }
  }

  colorScale = () => scaleLinear()
    .domain([
      this.props.variable.low, 
      (this.props.variable.high + this.props.variable.low)/(2.0), 
      this.props.variable.high, 
    ]).range([LOWCOLOR, MIDCOLOR, HIGHCOLOR])

  componentDidUpdate = (prevProps, prevState, snapshot) => {
    if(this.state.forceUpdate){
      this.setState({
        forceUpdate: false
      })
    }
  }


  handleZoomIn = () => {
    this.setState({ zoom: this.state.zoom * 1.15, })
  }

  handleZoomOut = () => {
    this.setState({ zoom: this.state.zoom / 1.15, })
  }

  handleClick = () =>
    this.setState((prevState, props) => {return{clicked: !this.state.clicked}})

  handleMouseOver = (e, geo) => 
    this.setState({hovered: true, hoverData: geo})

      
  handleWheel = (wheel, info) => {
   if( wheel.deltaY > 0) {
     this.handleZoomOut()
   } else if (wheel.deltaY < 0) {
     this.handleZoomIn()
   }
   wheel.preventDefault()
  }

  render() {
    if(this.props.disabled)
      return(
        <div>
          <h1 style={{margin: '15%', textAlign: 'center'}}> 
            Please select a data variable to show the map
          </h1>
        </div>)
    else
      return(
        <div style={{display:'flex', flexDirection:'column', height:'100%', width: '100%'}}>
          <h3 style={{borderBottom: '1px solid grey', paddingBottom: '5px', margin:'0'}}> {this.props.variable.label} </h3>
          <hr />
          <div style={{display: 'flex', flexGrow: '2', height:'100%', width: '100%'}}>  
            {this.state.hovered && 
              <InfoBox 
                data={ this.state.hoverData } 
                variable={ this.props.variable }
                expanded={ this.state.clicked }
                vars={ this.props.vars }
                collapse={ this.handleClick }
                lang={ this.props.lang }
              />
            }
            <div id='chart-output' style={{display: 'flex', width: '100%', height: '100%', overflow: 'hidden', justifyContent: 'center'}}>
              <ComposableMap 
                width={this.state.width} 
                height={this.state.height} 
                projectionConfig={{scale: 6000,}}
              >

              <ZoomableGroup center={[-90.5, 15.5]} zoom={ this.state.zoom } >
                <Geographies 
                  geography={ this.props.geoData} 
                  disableOptimization={ this.state.forceUpdate }
                > 
                  {(geographies, projection) => geographies.map((geography, i) => {
                  geography.properties['data'] = getDataByLocation(geography.properties, this.props.data) 
                  return(
                    <Geography
                      key={ geography.id }
                      geography={ geography }
                      cacheId={ 'geography-' +  geography.properties.ID_2 + geography.properties.ID_1 + this.props.geoData[0]}
                      projection={ projection }
                      onClick={ this.handleClick }
                      onMouseOver={ (e) => this.handleMouseOver(e, geography.properties)}
                      onMouseLeave={ this.handleMouseExit }
                      onWheel={ this.handleWheel }
                      style = {{
                        default: { 
                          fill: this.colorScale()(geography.properties.data[this.props.variable.code]),
                          stroke: '#000',
                          strokeWidth: '0.2',
                          outline: 'none',
                        },
                        hover:   { 
                          fill: "#999",
                          boxShadow: '10px 3px red',
			  cursor: 'pointer',
                        },
                      }}
                    />
                  )}
                )}
                </Geographies>
              </ZoomableGroup>
            </ComposableMap>
          </div>
          <div style={zoomButtons}> 
            <button 
              style={Object.assign({}, button, 
                        {
                          borderBottom: '1px solid #e6e6e6',
                          padding: '4px',
                        }
                        )
                    } 
              onClick={ this.handleZoomIn }> 
              { '+' } 
            </button> 

            <button style={ button } onClick={ this.handleZoomOut }> { '-' } </button> 
          </div>
          </div>
        </div>
      )
    }
  }

