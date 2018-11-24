import React, { Aux, Component } from 'react'
import { ScatterPlot } from 'react-d3-components'
import * as d3 from 'd3';

class DispersionChart extends Component {
  constructor(props) {
    super(props);
    const { transactions } = props;

    this.state = {}
    this.data = {
      values: transactions.map(t => ({y: +t.amount, x: new Date(t.date).getUTCDate() }))
    };
    console.log(this.data);
  }

  render() {
    const scatterProps = {
      width: 4000,
      height: 400,
      data: this.data,
      minX: 31,
      xScale: d3.time.scale().domain([1, 31]).range([0, 400 - 70]),
    };
    return (
      <div>
        <h1>Gráficos</h1>
        <ScatterPlot {...scatterProps} />
      </div>
    )
  }
}

export default DispersionChart;
