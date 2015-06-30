require 'net/http'
require 'uri'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Video
  attr_accessor :url, :filename, :fmt_data

  def initialize(url, filename, fmt_data)
    @url, @filename, @fmt_data = url, filename, fmt_data
  end

  def download(dir=Dir.pwd)
    Thread.new(dir) { _download(dir) }
  end

  def _download(dir)
    if !Dir.exist?(dir)
      raise "Directory doesn't exist"
    end

    file_name = File.join(dir, @filename+"."+@fmt_data["extension"])

    if (File.exist?(file_name))
      raise "File Already Exists"
    end

    uri = URI(@url)
    begin
      Net::HTTP.get_response(uri) { |res|
        if res != nil && res.is_a?(Net::HTTPSuccess)
          f = File.new(file_name, "wb")
          res.read_body do |chunk|
            f.write(chunk)
          end
          f.close()
        end
      }
    end
  end
end