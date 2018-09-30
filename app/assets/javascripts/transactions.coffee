# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  console.info 'transactions.coffee loaded'
  matches = location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)
  year = matches[1]
  month = matches[2]
  $('select').change (e) ->
    console.debug "New filter #{e.target.value}"
    window.location = "/transactions/#{year}/#{month}/groupby/#{e.target.value}"
