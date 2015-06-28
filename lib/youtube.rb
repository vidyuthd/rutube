require 'util'

class Youtube
  attr_accessor :file_name, :video_url, :video_id, :fmt_values, :videos, :title

  def initialize(file_name, video_url)
    @file_name, @video_url = file_name, video_url
    initialize_video_info(self)
  end

  def initialize_video_info(yt)
    yt.title = ""
    yt.videos = []
    uri = URI(yt.video_url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPMovedPermanently) && uri.scheme == "http"
      puts "Changing the url scheme to https since redirections are not handled by ruby"
      uri.scheme = "https"
      uri.port = 443
      response = Net::HTTP.get_response(uri)
    end

    if response != nil && response.is_a?(Net::HTTPSuccess)
      content = response.body
      player_conf = content[17 + content.index("ytplayer.config = ")..content.length]
      bracket_count = 0
      index = 0
      player_conf.each_char.with_index { |char, i|
        index = i
        if char == "{"
          bracket_count += 1
        elsif char == "}"
          bracket_count -= 1
          if bracket_count == 0
            break
          end
        end
      }

      index = index+1
      data = JSON.parse(player_conf[0, index])

      is_vevo = false
      if ['vevo', 'dashmpd'].include?(data["args"]["pk"])
        is_vevo = true
      end

      stream_map = Util.parse_stream_map(data["args"]["url_encoded_fmt_stream_map"])
      yt.title = data["args"]["title"]
      js_url = "http:" + data["assets"]["js"]
      video_urls = stream_map["url"]

      yt.videos, yt.fmt_values = [], []

      video_urls.each_with_index { |url, index|
        begin
          fmt, fmt_data = Util._extract_fmt(url)
        rescue StandardError
          puts $!, $@
        end

        if url.index('signature=') == nil
          if is_vevo
            ## TODO : need to handle it differently
          else
            signature = _cipher(stream_map["s"][i], js_url)
            url = "%url&signature=%sig".gsub('url', url).gsub('sig', signature)
          end
        end

        yt.videos.push(Video.new(url, yt.file_name, fmt_data))
        yt.fmt_values.push(fmt)
      }
    end
    return yt
  rescue JSON::JSONError
    puts "cannot decode json"
  end


  def get(type)
    return_videos = []

    for video in @videos
      if video.fmt_data["extension"] == type
        return_videos.push(video)
        break
      end
    end

    if return_videos.length == 1
      return return_videos[0]
    else
      return nil
    end

  end
end