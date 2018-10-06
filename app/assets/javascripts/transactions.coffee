# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

closeAlerts = ->
  console.log 'Closing alerts'
  $('.alert').alert 'close'

ready = ->
  console.info 'transactions.coffee loaded', new Date()

  setTimeout closeAlerts, 2000

  if location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)
    [_, year, month] = location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)
    console.log "year #{year}, month #{month}"
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

    $('#groupby').change (e) ->
      console.debug "New filter #{e.target.value} #{year} #{month}"
      window.location = "/transactions/#{year}/#{month}/groupby/#{e.target.value}"

    $('.category-select').change (e) ->
      e.preventDefault()
      console.debug "Category changed"
      tid = $(e.target).data 'transaction'
      cat = e.target.value
      color = $(e.target).find("[value=#{cat}]").data('color')
      console.debug 'color', color
      $(e.target).parent().parent().find('td .hidden.loading').show(200).delay(10).addClass('spin-animation')
      $.ajax "/transactions/category/#{tid}/#{cat}",
        type: 'patch'
        data:
          authenticity_token: window._token
        success: ->
          console.log 'Success'
          $(e.target).css('background-color', color)
          $(e.target).parent().parent().find('td .loading').hide(200)
          $(e.target).parent().parent().find('td .hidden.success').show(200).delay(500).hide(200)
        error: ->
          $(e.target).value('ERRO').attr('background-color', '#ff0000')
          console.error arguments

$(document).on('ready turbolinks:load', ready)
