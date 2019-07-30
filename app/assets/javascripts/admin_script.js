$(document).ready(function() {
  $('#datatable').DataTable();

  $(".delete-user").on("click", function(){
    var id = $(this).val();
    var user = $(this).parents(".admin-user");
    $.ajax({
      url: '/admin/users/'+ id,
      type: 'DELETE',
      dataType: 'JSON',
    }).then(function(result){
      if (result.status)
      user.remove();
    })
  });

  $(".block-user").on("click", function(){
    var id = $(this).val();
    var block = this;
    $.ajax({
      url: '/admin/block_user/'+ id,
      type: 'GET',
      dataType: 'JSON',
    }).then(function(result){
      if (result.status){
        block.innerText = result.block
      }
    })
  });

  $(".delete-post").on("click", function(){
    var id = $(this).val();
    var post = $(this).parents(".admin-post");
    $.ajax({
      url: '/admin/posts/'+ id,
      type: 'DELETE',
      dataType: 'JSON',
    }).then(function(result){
      if (result.status)
      post.remove();
    })
  });

  $(".block-post").on("click", function(){
    var id = $(this).val();
    var block = this;
    $.ajax({
      url: '/admin/block_post/'+ id,
      type: 'GET',
      dataType: 'JSON',
    }).then(function(result){
      if (result.status){
        block.innerText = result.block
      }
    })
  });
});
