function adjust_sit_title_to_diary_type() {
  if ( !document.getElementById('sit_title') ) { return null }

  if ($('#sit_s_type_meditation').is(':checked')) {
    $('.duration-form-group').show();
    $('.sit-title-form-group').hide();
    document.getElementById('sit_title').required = false;
    document.getElementById('sit_duration').disabled = false;
    document.getElementById('sit_duration').required = true;
    $('#js-wat-meditation').show();
    $('#js-wat-journal').hide();
  }

  else {
    $('.duration-form-group').hide();
    $('.sit-title-form-group').show();
    document.getElementById('sit_title').required = true;
    document.getElementById('sit_duration').disabled = true;
    document.getElementById('sit_duration').required = false;
    $('#js-wat-meditation').hide();
    $('#js-wat-journal').show();
  }
}


$(document).ready(function(){

  $.each($('.rich-textarea'), function(index, el){
    $(el).wysihtml5({
      toolbar: {
        "font-styles": false, //Font styling, e.g. h1, h2, etc. Default true
        "emphasis": true, //Italics, bold, etc. Default true
        "lists": true, //(Un)ordered lists, e.g. Bullets, Numbers. Default true
        "html": true, //Button which allows you to edit the generated HTML. Default false
        "link": true, //Button to insert a link. Default true
        "image": false, //Button to insert an image. Default true,
        "color": false, //Button to change color of font,
        "fa": true
      }
    });
  });

  adjust_sit_title_to_diary_type();

  $('[name="sit[s_type]"]').change( function() { adjust_sit_title_to_diary_type() });

  // Privacy dropdown
  $('.sits-new .dropdown-menu').click(function(e) { e.stopPropagation(); });
  $('.sits-edit .dropdown-menu').click(function(e) { e.stopPropagation(); });

  // http://eonasdan.github.io/bootstrap-datetimepicker/Options/
  $('[data-plugin="datetimepicker"]').datetimepicker({
    // locale: "ru",
    useCurrent: true,
    showTodayButton: true,
    icons: {
      clear:    'fa fa-trash',
      close:    'fa fa-remove',
      date:     'fa fa-calendar',
      down:     'fa fa-chevron-down',
      next:     'fa fa-chevron-right',
      previous: 'fa fa-chevron-left',
      time:     'fa fa-clock-o',
      today:    'fa fa-dot-circle-o',
      up:       'fa fa-chevron-up'
    }
  });

  // https://github.com/tsechingho/chosen-rails
  $(".chosen-select").chosen({ max_selected_options: 1 });

  // FAVOURITES / add and remove
  $('#favourite_button').on('click', '.toggle-favourite', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  // VIEW SIT / Likers list
  $("#likers-list").tooltip();

  // VIEW SIT / Report
  $('.report-flag').tooltip();

  $('[data-toggle="tooltip"]').tooltip();


  // VIEW PROFILE / Date select
  $('#js-stream-date-navigation').change( function() {
    window.location.href = $(this).val();
  });

  // VIEW PROFILE / Full profile
  $('.expand-profile').click( function(e) {
    e.preventDefault();
    $('.full-profile').slideToggle();
  })

  // LIKES / a sit
  $('#like_button').on('click', '.toggle-like', function(e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  // REPORTS / a sit
  $('.report-flag').on('click', function(e) {
    e.preventDefault();
    $('.report-modal').modal();
  });

  // MASONRY
  if ($('.page-content.me .sit-container').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp"
    });
  }

  if ($('.page-content.favourites').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp"
    });
  }

  if ($('.page-content.explore').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp"
    });
  }

  if ($('.front-page').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-2',
      itemSelector: '.tile',
      stamp: ".stamp",
    });
  }

  // if ($('.view-user').length) {
  //   var container = document.querySelector('.sit-container');
  //   var msnry = new Masonry( container, {
  //     columnWidth: '.col-md-4',
  //     itemSelector: '.tile',
  //     stamp: ".stamp",
  //   });
  // }

  if ($('.tags-show').length) {
    var container = document.querySelector('.sit-container');
    var msnry = new Masonry( container, {
      columnWidth: '.col-md-3',
      itemSelector: '.tile',
      stamp: ".stamp",
    });
  }

  // GOALS
  $('[name="goal[goal_type]"]').change(function() {
    if ($(this).val() == 'ongoing') {
      $('.fixed_toggle').hide();
      $('.ongoing_toggle').fadeIn();
    } else {
      $('.ongoing_toggle').hide();
      $('.fixed_toggle').fadeIn();
    }
  });

  // Finish this goal?
  $('.goal').hover(function() {
    $(this).find('.finish-goal').toggle();
  })

  // Add another one
  $('.toggle-goal-form').click( function (e) {
    e.stopPropagation();
    $('.new-goal-form').toggle();
  })

  // Show completed
  $('.show-completed').click( function(e) {
    e.stopPropagation();
    $('.completed-goals').toggle();
    $('.show-completed').hide();
    $('.hide-completed').show();
  });

  // Hide completed
  $('.hide-completed').click( function(e) {
    e.stopPropagation();
    $('.completed-goals').toggle();
    $('.show-completed').show();
    $('.hide-completed').hide();
  });

  // Report
  $('#new_report .submit-report').click(function(e) {
    e.stopPropagation();
    $('.report-modal .form-group.select.report_reason').removeClass('has-error');
    $('.report-modal .form-group.text.report_body').removeClass('has-error');

    if (!$('#report_reason').val()) {
      $('.report-modal .form-group.select.report_reason').addClass('has-error');
      $('#report_reason').focus();
      return;
    }

    if (!$('#report_body').val()) {
      $('.report-modal .form-group.text.report_body').addClass('has-error');
      $('#report_body').focus();
      return;
    }

    $('.simple_form.new_report').submit();
  });

  $('#users-select').change(function (e) {
    window.location.href = $(this).val();
  });

  $('#sits-select').change(function (e) {
    window.location.href = '/explore?visibility=' + $(this).val();
  });

  $('.sit-delete-icon').click(function(e) {
    let redirectUrl = $(this).data('redirect-url');

    if (confirm($(this).data('confirm-message'))) {
      $.ajax({
        method: 'DELETE',
        url: '/sits/' + $(this).data('id')
      }).done(function(data) {
        if (data.status == 'ok') {
          if (redirectUrl) {
            window.location.href = redirectUrl;
          } else {
            window.location.reload();
          }
        }
      });
    }
  });
});

// https://github.com/Nerian/bootstrap-wysihtml5-rails
// $(document).on('page:load', function(){
//   window['rangy'].initialized = false
// })
