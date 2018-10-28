import React from "react"
import PropTypes from "prop-types"
// import * as moment from 'moment';


const stepByAmountDate = (amount, date) => {
  const today = new Date();
  const [dyear, dmonth] = date.split('-');
  const year = today.getFullYear();
  const month = today.getMonth();
  const years = dyear - year;
  const months = years * 12;
  return Math.floor(amount / months);
}

const dateByAmountStep = (amount, step, max) => {
  const months = Math.floor(amount / step);
  console.log(months);
  if (months === 0 || months > max)
    return 'inf'
  return moment().add(months, 'month').format('YYYY-MM')
}

const isNumber = (value) => {
  return value.length === 0 || value.match(/^\d+$/)
}

class Goals extends React.Component {
  constructor(props) {
    super()
    const amount = 10000;
    const step = 500;
    this.state = {
      amount: amount,
      step: step,
      date: dateByAmountStep(amount, step, props.maxMonths), 
      months: Math.floor(amount / step),
    }
  }

  onAmountChange = e => {
    const value = e.target.value;
    if (!isNumber(value))
      return;

    this.setState(prev => ({
      amount: value,
      date: dateByAmountStep(value, prev.step, this.props.maxMonths),
    }));
  }

  onStepChange = e => {
    const value = e.target.value;
    if (!isNumber(value))
      return;
    
    this.setState(prev => ({
      date: dateByAmountStep(prev.amount, value, this.props.maxMonths),
      step: value,
    }));
  }

  onDateChange = e => {
    const value = e.target.value;
    this.setState(prev => ({
      date: value,
      step: stepByAmountDate(prev.amount, value),
    }));
  }

  render () {
    const dstart = moment().add(1, 'monht');
    const dend = moment().add(this.props.maxMonths, 'month');
    const infopt = k => <option key={k} value='inf'>Inválido</option>
    var opts = [infopt('thismonth')]
    for (var d = dstart; d.isBefore(dend); d.add(1, 'month')) {
      const df = d.format('YYYY-MM');
      opts.push(<option key={df} value={df}>{df}</option>);
    }
    opts.push(infopt('inf'));
    return (
      <div>
        <form>
          <div className='form-group'>
            <label htmlFor='goal-step' className='form-label'>Quanto você pode investir por mês?</label>
            <input name='step' id='goal-step' className='form-control' type='number' step='100' onChange={this.onStepChange} value={this.state.step} />
          </div>
          <div className='form-group'>
            <label htmlFor='goal-date' className='form-label'>Você vai ter {this.state.amount / 1000} mil em:</label>
            <select className='form-control' name='date' value={this.state.date} onChange={this.onDateChange}>
              {opts}
            </select>
          </div>
          <button name='GoalSubmit' className='btn btn-primary' type='submit'>Submit</button>
        </form>
      </div>
    );
  }
}

Goals.defaultProps = {
  maxMonths: 60,
}
export default Goals
