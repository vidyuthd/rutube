#Rutube (spelled as R youtube)

Simple light weight dependency free ruby port of pytube for downloading videos.

##Requirements
* ruby 2.0+
* RubyGems

##Usage
* install the gem using following command - **gem install rutube** 
* usage in code
```ruby
  require 'rutube'  
       
  yt = Youtube.new("Dancing Scene from Pulp Fiction.mp4","http://www.youtube.com/watch?v=Ik-RsDGPI5Y")
  video = yt.get("mp4")
  video.download()
```  

##Thanks
NFicano [Github username]