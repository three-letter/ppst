require 'net/http'
require File.expand_path("../../../lib/crypt-xxtea/xxtea", __FILE__)
module CastsHelper

  def get_result
    url, sn, key = "http://v.ku6vms.com/v3/api", "27bf6226213cf288dfbf62ffc02bad4f", "b6914f0cdacde53bfe6751ac05880111"
    time = Time.now.to_i
    crypt = XXTEA.encrypt(key, time.to_s) 
    url = URI.parse(url) unless url.is_a?(URI) 
    conn = Net::HTTP.new(url.host, url.port)
    rsp = conn.get("/v3/api?method=GetFlashUploadParam&sn=#{sn}&posttime=#{time}&token=#{crypt}", {})
    rsp.body
  end
end
