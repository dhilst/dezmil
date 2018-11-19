$(document).on('ready turbolinks:load', function(){
  console.log('ready')
  $('#goal_category_id').on('change', function(e) {
    console.log('change')
    var id = $(e.target).val()
    $.ajax({
      url: '/transactions/by/category/' + id + '/amount',
      success: function(amount){
        console.log(amount);
        $('#goal_amount').val(JSON.parse(amount));
      },
    });
  });
});
