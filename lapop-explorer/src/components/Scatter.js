import React, { Component } from 'react';
import { Scatter } from 'react-chartjs-2';

export class ScatterChart extends Component {
  constructor(props) {
    super(props)
		this.state = {
      height: 200,
      width: 200
    }
  }

  getChartData = () => {
    const x = this.props.depVar.code
    const y = this.props.indepVar.code 
    const data = this.props.data 
    return Object.values(data[x]).map(
      (datum, i) => {
        return {x: datum, y: data[y][i]}
      }
    )
  }

  resize = () => {                                                         
   let el = document.getElementById('chart-output')                        
    if(el) 
    {                                                                      
      this.setState({                                                      
        height: el.offsetHeight,                                           
        width: el.offsetWidth                                              
      })                                                                   
    }                                                                      
  }
	
  componentDidMount = () => this.resize()

  componentWillMount = () => 
    window.addEventListener('resize', this.resize())

  componentWillUnmount = () => 
    window.removeEventListener('resize', this.resize())

  tooltipLabel = (tooltipItems, data) =>  (' ' 
    + this.props.labels[tooltipItems.index] 
    + ' (' + tooltipItems.xLabel.toFixed(1) + ', ' 
    + tooltipItems.yLabel.toFixed(1) + ')')

  chartData = () => {
    return {
      labels: ['scatter'],
      datasets: [{
        label: '',
        backgroundColor: '#FFF',
        pointBackgroundColor: '#057cfa',
        borderColor: '#FFF',
        data: this.getChartData()
      }],
		}
	}

	chartOptions = () => {
		return {
			maintainAspectRatio: true,
			scales: {
				yAxes: [{
					scaleLabel: {
						display: true,
						labelString: this.props.indepVar.label
					}
				}],
				xAxes: [{
					scaleLabel: {
						display: true,
						labelString: this.props.depVar.label
					}
				}],
			},
      tooltips: {
        callbacks: {
          label: this.tooltipLabel 
          }
        }
      }
		}

	render() {
    if(this.props.disabled)
      return(
        <div>
          <h1 style={{margin: '15%', textAlign: 'center'}}>
            Please select an X variable and a Y variable to display the chart
          </h1>
        </div>)
    else
			this.resize()
      return(
        <div style={{backgroundColor:'white'}}>
          <h3 style={{borderBottom: '1px solid grey', paddingBottom: '5px', margin:'0'}}> {this.props.depVar.label + ' vs ' + this.props.indepVar.label} </h3>
          <Scatter 
            data={ this.chartData()}
            options={this.chartOptions()}
            width={this.state.width}
            height={this.state.height}
            />
        </div>
      )
    }
  }

