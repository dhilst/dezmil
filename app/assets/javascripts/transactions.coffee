# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  console.info 'transactions.coffee loaded'

  [_, year, month] = location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)

  body = $('body')[0]
  hammertime = new Hammer body
  hammertime.on 'pan', (e) ->
    console.log e.additionalEvent
    if e.additionalEvent == 'panright'
      $('#prev')[0].click()
    else if e.additionalEvent == 'panleft'
      $('#next')[0].click()


  $('select').change (e) ->
    console.debug "New filter #{e.target.value}"
    window.location = "/transactions/#{year}/#{month}/groupby/#{e.target.value}"
