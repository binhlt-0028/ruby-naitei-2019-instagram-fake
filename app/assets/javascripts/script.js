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

  $(document).on('click', '.edit_post', function (e) {
    e.preventDefault();
    var id = $(this).val();
    $.ajax({
        url: '/posts/'+ id + '/edit',
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
  $('.new_comment').on('keypress', function (e) {
    var input = $(this);
    if(e.which == 13){
      var post_id = input.parent().find('.post_id').val();
      var content = input.val();
      $.ajax({
        url: '/comments',
        type: 'POST',
        dataType: 'JSON',
        data:{
          post_id: post_id,
          content: content
        }
      }).done(function(result) {
        if(result.status == json_stt.SUCCESS){
          input.parents('.post-element').find('.comment-count span').html(result.data.count);
          var html = '<div class=\"comment-element d-flex\">'
                  + '<div class=\"comment-content\">'
                  + '<a href=\"users/'+ result.data.user_id +'\">'
                  + result.data.username+'</a> '
                  + result.data.content
                  + '</div>'
                  + '<div class=\"dropdown ml-auto\">'
                  + '<a href=\"#\" data-toggle=\"dropdown\">'
                  + '<span class=\"fa fa-ellipsis-v\"></span>'
                  + '</a>'
                  + '<div class=\"dropdown-menu dropdown-menu-right\"'
                  + 'aria-labelledby=\"dropdownMenuLink\">'
                  + '<button class=\"dropdown-item edit_cmt\"'
                  + 'value=\"'+ result.data.id +'\">Edit</button>'
                  + '<button class=\"dropdown-item del_cmt\"'
                  + 'value=\"'+ result.data.id +'\">Delete</button>'
                  + '</div>'
                  + '</div>'
                  + '</div>';
          var list_box = input.parents('.post-element').find('.comment-show .comment-list');
          list_box.prepend(html);
          input.val("");
        }
      });
    }
  })

  $(document).on('click', '.del_cmt', function () {
    var del_btn = $(this);
    var id = $(this).val();
    $.ajax({
        url: '/comments/'+ id,
        type: 'DELETE',
        dataType: 'JSON',
    }).done(function(result) {
      if(result.status == json_stt.SUCCESS){
        del_btn.parents('.post-element').find('.comment-count span').html(result.data);
        del_btn.parents('.comment-element').remove();
      }
    });
  })

  $(document).on('click', '.edit_cmt', function () {
    var edit_btn = $(this);
    var id = $(this).val();
    $.ajax({
        url: '/comments/'+ id+'/edit',
        type: 'GET',
        dataType: 'JSON',
    }).done(function(result) {
      var edit_box = edit_btn.parents('.comment-element');
      var html = '<input type=\"text\" class=\"form-control edit_cmt_input\"'
              +'value=\"'+ result.content +'\">'
              + '<input type=\"text\" class=\"d-none edit_id\" value=\"'+ id +'\">';
      edit_box.html(html);
    });
  })

  $(document).on('keypress','.edit_cmt_input', function (e) {
    var edit_input = $(this);
    if(e.which == 13){
      var content = $(this).val();
      var id = $(this).parent().find('.edit_id').val();
      $.ajax({
          url: '/comments/'+ id,
          type: 'PATCH',
          dataType: 'JSON',
          data: {
            content: content
          }
      }).done(function(result) {
        if(result.status == json_stt.SUCCESS){
          var html = '<div class=\"comment-content\">'
                  + '<a href=\"users/'+ result.data.user_id +'\">'
                  + result.data.username+'</a> '
                  + result.data.content
                  + '</div>'
                  + '<div class=\"dropdown ml-auto\">'
                  + '<a href=\"#\" data-toggle=\"dropdown\">'
                  + '<span class=\"fa fa-ellipsis-v\"></span>'
                  + '</a>'
                  + '<div class=\"dropdown-menu dropdown-menu-right\"'
                  + 'aria-labelledby=\"dropdownMenuLink\">'
                  + '<button class=\"dropdown-item edit_cmt\"'
                  + 'value=\"'+ result.data.id +'\">Edit</button>'
                  + '<button class=\"dropdown-item del_cmt\"'
                  + 'value=\"'+ result.data.id +'\">Delete</button>'
                  + '</div>'
                  + '</div>';
          var edit_box = edit_input.parents('.comment-element');
          edit_box.html(html);
        }
      });
    }
  })
})

function create_reaction(type_class, show_element, reac_count_tag){
    var type_id = type_class.replace(/\-/g,'_');
    var post_id = reac_count_tag.find('.post_id').val();
    $.ajax({
        url: '/reactions',
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
        url: '/reactions/'+id,
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
        url: '/reactions/'+id,
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
