
grabVideoUrl = ->
  $("meta[name=url-token]").attr("content")

playVideo = ->
  url = grabVideoUrl()
  if url?
    $("#jquery_jplayer_1").jPlayer
      ready: ->
        $(this).jPlayer("setMedia", {m4v: "http://ppst.qiniudn.com/" + url,poster: "http://ppst.qiniudn.com/" + url + "?vframe/jpg/offset/10/w/640/h/360"
        })
      swfPath: "/assets"
      supplied: "m4v"
      size: { width: "640px", height: "360px", cssClass: "jp-video-360p"}

$ ->
  playVideo()
