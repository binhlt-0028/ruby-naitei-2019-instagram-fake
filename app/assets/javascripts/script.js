const json_stt = {
  ERROR: 404,
  SUCCESS: 200
}
const REACTION_DEFAULT_CLASS = "far fa-thumbs-up";

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

  $('.reaction-count .dropdown-menu i.far').on('click', function () {
    var clicked = $(this);
    var reac_count_tag = clicked.parents('.reaction-count');
    var type_class = clicked.attr('class').split(' ')[1];
    var show_element = reac_count_tag.find('.show_reaction');
    if(show_element.children('i').hasClass(REACTION_DEFAULT_CLASS))
      create_reaction(type_class, show_element, reac_count_tag);
    else if(show_element.children('i').hasClass(type_class))
      destroy_reaction(show_element, reac_count_tag);
    else
      update_reaction(type_class, show_element, reac_count_tag);
  })
})

function create_reaction(type_class, show_element, reac_count_tag){
    var type_id = type_class.replace(/\-/g,'_');
    var post_id = reac_count_tag.find('.post_id').val();
    $.ajax({
        url: 'reactions',
        type: 'POST',
        dataType: 'JSON',
        data:{
          post_id: post_id,
          type_id: type_id
        }
    }).done(function(result) {
      if(result.status == json_stt.SUCCESS){
        var show_i_tag = show_element.children('i');
        show_i_tag.removeClass();
        show_i_tag.addClass("fas");
        show_i_tag.addClass(type_class);
        reac_count_tag.find('.reaction_id').val(result.data.id);
        show_element.children('span').html(result.data.count);
        reac_count_tag.find('a').addClass('active');
      }
    });
}

function destroy_reaction(show_element, reac_count_tag){
  var id = reac_count_tag.find('.reaction_id').val();
  $.ajax({
        url: 'reactions/'+id,
        type: 'DELETE',
        dataType: 'JSON',
    }).done(function(result) {
      if(result.status == json_stt.SUCCESS){
        var show_i_tag = show_element.children('i');
        show_i_tag.removeClass();
        show_i_tag.addClass(REACTION_DEFAULT_CLASS);
        reac_count_tag.find('.reaction_id').val("");
        show_element.children('span').html(result.data.count);
        reac_count_tag.find('a').removeClass('active');
      }
    });
}

function update_reaction(type_class, show_element, reac_count_tag){
  var id = reac_count_tag.find('.reaction_id').val();
  var type_id = type_class.replace(/\-/g,'_');
  $.ajax({
        url: 'reactions/'+id,
        type: 'PATCH',
        dataType: 'JSON',
        data:{
          type_id: type_id
        }
    }).done(function(result) {
      if(result.status == json_stt.SUCCESS){
        var show_i_tag = show_element.children('i');
        show_i_tag.removeClass();
        show_i_tag.addClass("fas");
        show_i_tag.addClass(type_class);
        show_element.children('span').html(result.data.count);
      }
    });
}
