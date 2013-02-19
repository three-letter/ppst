
grabVideoUrl = ->
  $("meta[name=url-token]").attr("content")

playVideo = ->
  url = grabVideoUrl()
  if url?
    $("#jquery_jplayer_1").jPlayer
      ready: ->
        $(this).jPlayer("setMedia", {
          m4v: "http://ppst.qiniudn.com/" + url
        })
      swfPath: "/assets"
      supplied: "m4v"
      size: { width: "640px", height: "360px", cssClass: "jp-video-360p"}

$ ->
  playVideo()
