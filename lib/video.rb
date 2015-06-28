require 'net/http'
require 'uri'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Video
  attr_accessor :url, :filename, :fmt_data

  def initialize(url, filename, fmt_data)
    @url, @filename, @fmt_data = url, filename, fmt_data
  end

  def download
    if (File.exist?(@filename))
      raise "File Already Exists "
    end

    uri = URI(@url)
    begin
      Net::HTTP.get_response(uri) { |res|
        f = File.new(@filename, "wb")
        res.read_body do |chunk|
          f.write(chunk)
        end
        f.close()
      }
    end
  end
end