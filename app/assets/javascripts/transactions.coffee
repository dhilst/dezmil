# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

 
$ ->
  console.info 'transactions.coffee loaded'

  if location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)
    [_, year, month] = location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)
    body = $('body')
    hammertime = new Hammer body
    hammertime.on 'pan', (e) ->
      console.log e.additionalEvent
      if e.additionalEvent == 'panright'
        $('body').hide('slide', { direction: 'left' }, 500)
        $('#prev')[0].click()
      else if e.additionalEvent == 'panleft'
        $('body').hide('slide', { direction: 'right' }, 500)
        $('#next')[0].click()

  closeAlerts = ->
    console.log 'Closing alerts'
    $('.alert').alert 'close'

  setTimeout closeAlerts, 2000

  $('#groupby').change (e) ->
    console.debug "New filter #{e.target.value}"
    window.location = "/transactions/#{year}/#{month}/groupby/#{e.target.value}"

  $('.category-select').change (e) ->
    console.debug "Category changed"
    tid = $(e.target).data 'transaction'
    cat = e.target.value
    $.ajax "/transactions/category/#{tid}/#{cat}",
      type: 'patch'
      data:
        authenticity_token: window._token
      success: ->
        console.log 'Success'
      error: ->
        console.error arguments



