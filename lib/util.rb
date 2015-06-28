require 'net/http'
require 'json'
require 'openssl'
require 'video'
require 'uri'

class Array
  def iterate!(code)
    self.each_with_index do |n, i|
      self[i] = code.call(n)
    end
  end
end

module Util

  YT_BASE_URL = 'http://www.youtube.com/get_video_info'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

# YouTube quality and codecs id map.
# source: http://en.wikipedia.org/wiki/YouTube#Quality_and_codecs
  YT_ENCODING = {
      # Flash Video
      5 => ["flv", "240p", "Sorenson H.263", "N/A", "0.25", "MP3", "64"],
      6 => ["flv", "270p", "Sorenson H.263", "N/A", "0.8", "MP3", "64"],
      34 => ["flv", "360p", "H.264", "Main", "0.5", "AAC", "128"],
      35 => ["flv", "480p", "H.264", "Main", "0.8-1", "AAC", "128"],

      # 3GP
      36 => ["3gp", "240p", "MPEG-4 Visual", "Simple", "0.17", "AAC", "38"],
      13 => ["3gp", "N/A", "MPEG-4 Visual", "N/A", "0.5", "AAC", "N/A"],
      17 => ["3gp", "144p", "MPEG-4 Visual", "Simple", "0.05", "AAC", "24"],

      # MPEG-4
      18 => ["mp4", "360p", "H.264", "Baseline", "0.5", "AAC", "96"],
      22 => ["mp4", "720p", "H.264", "High", "2-2.9", "AAC", "192"],
      37 => ["mp4", "1080p", "H.264", "High", "3-4.3", "AAC", "192"],
      38 => ["mp4", "3072p", "H.264", "High", "3.5-5", "AAC", "192"],
      82 => ["mp4", "360p", "H.264", "3D", "0.5", "AAC", "96"],
      83 => ["mp4", "240p", "H.264", "3D", "0.5", "AAC", "96"],
      84 => ["mp4", "720p", "H.264", "3D", "2-2.9", "AAC", "152"],
      85 => ["mp4", "1080p", "H.264", "3D", "2-2.9", "AAC", "152"],

      # WebM
      43 => ["webm", "360p", "VP8", "N/A", "0.5", "Vorbis", "128"],
      44 => ["webm", "480p", "VP8", "N/A", "1", "Vorbis", "128"],
      45 => ["webm", "720p", "VP8", "N/A", "2", "Vorbis", "192"],
      46 => ["webm", "1080p", "VP8", "N/A", "N/A", "Vorbis", "192"],
      100 => ["webm", "360p", "VP8", "3D", "N/A", "Vorbis", "128"],
      101 => ["webm", "360p", "VP8", "3D", "N/A", "Vorbis", "192"],
      102 => ["webm", "720p", "VP8", "3D", "N/A", "Vorbis", "192"]
  }

# The keys corresponding to the quality/codec map above.
  YT_ENCODING_KEYS = [
      'extension',
      'resolution',
      'video_codec',
      'profile',
      'video_bitrate',
      'audio_codec',
      'audio_bitrate'
  ]

  def parse_stream_map(text)
    videoinfo = {
        "itag" => [],
        "url" => [],
        "quality" => [],
        "fallback_host" => [],
        "s" => [],
        "type" => []
    }

    videos = text.split(",")
    videos.iterate!(lambda { |video| video.split("&") })
    for video in videos
      for kv in video
        key, value = kv.split("=")[0], URI.unescape(kv.split("=")[1])
        videoinfo[key].index(value) == nil ? videoinfo[key].push(value) : ""
      end
    end
    return videoinfo
  end

  module_function :parse_stream_map

  def _extract_fmt(url)
    fmt_data = Hash.new
    if itag = url.match('itag=\d+').to_s.match('\d+').to_s.to_i
      attr = YT_ENCODING[itag]
      if attr == nil
        return itag, fmt_data
      end
      lambda { |x, y| x.each_with_index { |i, j| fmt_data[i] = y[j] } }.call(YT_ENCODING_KEYS, attr)
      return itag, fmt_data
    end
  end

  module_function :_extract_fmt

  def _cipher(s, url)
    # TODO need to handle this by invoking js from ruby
  end
end