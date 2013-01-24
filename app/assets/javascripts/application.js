// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

$(document).ready(function(){
  
  // share cast after upload with ajax
  $("#cast_share_btn").click(function(){
    //var html = '<div style="width:200px;" class="progress progress-striped active"><div class="bar" style="width: 100%;">视频上传中,请稍后...</div></div>';
    //$("#cast_upload_info").html(html);
    //alert($("#cast_upload_info").html());
    $("#cast_share_form").submit();
  });

});
