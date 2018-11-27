import * as d3 from 'd3';
import * as axios from 'axios';

class PageDate {
	constructor() {
		if (location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)) {
			var dummy;
			[dummy, this.year, this.month] = location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/);
		} else {
			this.date = new Date();
			this.year = now.getFullYear();
			this.month = now.getMonth();
		}
	}
}

const ready = async () => {

  // Hacky
  if (location.pathname.match(/\/charts$/)) {
    $('#groupby').hide();
    $('.transactions-filter').hide();
  }

	const date = new PageDate();
	const response = await axios.get(`/transactions/${date.year}/${date.month}/charts.json`);
  const data = response.data.map(d => ({
    ...d,
    balance: +d.balance,
    date: new Date(d.date),
    amount: +d.amount,
    abs_amount: Math.abs(+d.amount),
  }));

  const width = 400, height = 400;
  const margin = 40;
  const mi = 10; // margin inner
  const yMin = d3.min(data.map(d => d.amount))
  const yMax = d3.max(data.map(d => d.amount))
  const svg = d3.select('.charts')
    .append('svg')
      .attr('width', width)
      .attr('height', height + 100)
      .append('g')
      .attr('transform', 'translate(0, 100)')


  const x = d3.scaleLinear().domain([1,31]).range([margin + mi, width - margin - mi])
  const y = d3.scaleLinear().domain([yMax, yMin]).range([margin, height - margin - mi]);
  const xAxis = d3.axisBottom(x).ticks(8)
  const yAxis = d3.axisLeft(y).ticks(5)


  const circles = svg
    .selectAll('circle')
    .data(data)
    .enter().append('circle')
      .attr('fill', d => d.color)
      .attr('stroke', d => 'black')
      .attr('r', d => 4)
      .attr('cx', d => x(d.date.getDate()))
      .attr('cy', d => y(d.amount))

  svg.append('g')
    .attr('transform', `translate(0, ${height - margin + 5})`)
    .call(xAxis)

  svg.append('g')
    .attr('transform', `translate(${margin}, 0)`)
    .call(yAxis)

  svg.append('text')
    .attr('transform', `translate(${margin}, ${height - margin + 30})`)
    .text('Dia')

  svg.append('text')
    .text('Dispersão')
    .attr('x', margin)
    .attr('y', 0)
    .attr('font-size', 32)

  {
    let x = 58,
      y = 60;

    svg.append('text')
      .text('R$')
      .attr('y', y)
      .attr('x', x)
      .attr('transform', `rotate(270 ${x} ${y})`)
  }

}

$(document).on('ready turbolinks:load', ready);
