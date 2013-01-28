require 'net/http'
require File.expand_path("../../../lib/crypt-xxtea/xxtea", __FILE__)
module CastsHelper

  def get_result
    time, crypt = XXTEA.encrypt_ku6
    url = URI.parse(XXTEA::URL) unless XXTEA::URL.is_a?(URI) 
    conn = Net::HTTP.new(url.host, url.port)
    rsp = conn.get("/v3/api?method=GetFlashUploadParam&sn=#{XXTEA::SN}&posttime=#{time}&token=#{crypt}", {})
    rsp.body
  end
end
