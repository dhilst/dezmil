function closeAlertOnClick(e) {
  $(e.target).parent('.alert-dismissable').slideUp(300, function(){
    $(e.target).alert('close');
  });
}

function ready() {
  console.info('[transactions] transactions.coffee loaded', new Date());

  var alerts = $('.alerts');
  alerts.on('click', '.alert-dismissable .fa-close', closeAlertOnClick);
  var alertsChildren = alerts.find('.alert');
  alertsChildren.each(function(i){
    setTimeout(function(){
      $(alertsChildren[i]).show("slide", { direction: "right"  });
      $(alertsChildren[i]).addClass('alert-show');
    }, i*100);
  });

  var year, month;
  if (location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/)) {
    var match = location.pathname.match(/transactions\/(\d{4})\/(\d{1,2})/);
    year = match[1];
    month = match[2];
  }

  $('#groupby').change(function(e){
    console.debug(`[transactions] New filter ${e.target.value} ${year} ${month}`);
    if (year === undefined || month === undefined) {
      var now = new Date();
      year = now.getFullYear();
      month = now.getMonth();
    }
    var loc = `/transactions/${year}/${month}/groupby/${e.target.value}`;
    window.location = loc;
  });


  $('.category-select').change(function(e){
    e.preventDefault();
    console.debug("[transactions] Category changed");
    var tid = $(e.target).data('transaction');
    var cat = e.target.value;
    var color = $(e.target).find(`[value=${cat}]`).data('color');
    console.debug('color', color);
    $(e.target).parent().parent().find('td .hidden.loading').show(200).delay(10).addClass('spin-animation');
    $.ajax(`/transactions/category/${tid}/${cat}`, {
      type: 'patch',
      data: { authenticity_token: window._token },
      success: function() {
        $(e.target).css('background-color', color);
        $(e.target).parent().parent().find('td .loading').hide(200);
        $(e.target).parent().parent().find('td .hidden.success').show(200).delay(500).hide(200);

        selects = $('select.category-select');
        if (location.search.match(/pattern=/i) &&
            selects.length > 1 &&
            confirm('Você gostaria de categorizar as outras transações da mesma forma?')) {
          selects.each(function(){
            var tselect = this;
            $(tselect).parent().parent().find('td .hidden.loading').show(200).delay(10).addClass('spin-animation');
            var tid = $(tselect).data('transaction');
            $.ajax(`/transactions/category/${tid}/${cat}`, {
              type: 'patch',
              data: { authenticity_token: window._token },
              success: function(){
                $(tselect).val(cat);
                $(tselect).css('background-color', color);
                $(tselect).parent().parent().find('td .loading').hide(200);
                $(tselect).parent().parent().find('td .hidden.success').show(200).delay(500).hide(200);
              }
            });
          });
        }
      },
      error: function(){
        $(e.target).value('ERRO').attr('background-color', '#ff0000');
        console.error('[transactions] ', arguments);
      }
    });
  });
}

$(document).on('ready turbolinks:load', ready);
