# coding: utf-8
Gem::Specification.new do |s|
  s.name = 'rutube'
  s.version = '0.4'
  s.licenses = ['MIT']
  s.authors = ["Vidyuth Dandu"]
  s.email = ["vidyuth.bitsgoa@gmail.com"]
  s.homepage = "https://github.com/vidyuthd/rutube"
  s.summary = %q{Download youtube videos using rutube}
  s.description = %q{Simple light weight dependency free ruby port of pytube for downloading youtube videos.}

  s.required_ruby_version = '>= 2.0.0'
  s.required_rubygems_version = '>= 1.3.6'

  s.files = Dir['{lib/*,test/*}']

  s.require_paths = ["lib"]
end
