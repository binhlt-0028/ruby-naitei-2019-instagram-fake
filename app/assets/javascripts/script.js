$(document).ready(function(){
  $('#new_post_input').on('focus',function () {
    $('#new_post_modal').modal('show');
  })

  $('#new_post_add_image').on('click', function () {
    $('#new_post_image').trigger('click');
  })

  $('#new_post_image').on('change', function () {
    input = $(this)[0];
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
})
