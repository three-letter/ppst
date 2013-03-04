
grabVideoUrl = ->
  $("meta[name=url-token]").attr("content")

playVideo = ->
  url = grabVideoUrl()
  if url?
    $("#jquery_jplayer_1").jPlayer
      ready: ->
        $(this).jPlayer("setMedia", {m4v: "http://ppstd.dn.qbox.me/" + url,poster: "http://ppstd.dn.qbox.me/" + url + "?vframe/jpg/offset/10/w/640/h/360"
        }).jPlayer("load")
      swfPath: "/assets"
      supplied: "m4v"
      size: { width: "640px", height: "360px", cssClass: "jp-video-360p"}

$ ->
  playVideo()
