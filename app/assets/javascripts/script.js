$(document).ready(function(){
  $.ajaxSetup({
    headers: {
      'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
    }
  });
  $('#new_post_input').on('focus',function () {
    $('#new_post_modal').modal('show');
  })

  $('#new_post_add_image').on('click', function () {
    $('#new_post_image').trigger('click');
  })

  $('#new_post_image').on('change', function () {
    input = $(this)[0];
    console.log(input.files);
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
          $('#preview_image img').attr('src', e.target.result);
          $('#preview_image').removeClass('d-none');
      };
      reader.readAsDataURL(input.files[0]);
    }
  })

  $('#remove_preview_image').on('click', function () {
    $('#preview_image img').attr('src', '');
    $('#preview_image').addClass('d-none');
  })

  $('.edit_post').on('click', function (e) {
    e.preventDefault();
    var id = $(this).val();
    $.ajax({
        url: 'posts/'+ id + '/edit',
        type: 'GET',
        dataType: 'JSON',
    }).done(function(result) {
        $('#edit_post_modal textarea').val(result.content);
        $('#edit_post_modal img').attr('src',result.image.url);
        $('#edit_post_modal form').attr('action','posts/'+result.id);
    });
    $('#edit_post_modal').modal('show');
  })
})
