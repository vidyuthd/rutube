#Rutube (pronounced as R youtube)

Simple light weight dependency free ruby port of pytube for downloading youtube videos.

##Requirements
* ruby 2.0+
* RubyGems

##Usage
* install the gem using following command - **gem install rutube** 
* usage in code
```ruby
  require 'rutube'  
       
  # Set the video URL
  yt = Youtube.new("http://www.youtube.com/watch?v=Ik-RsDGPI5Y")
  
  # Once set, you can see all the codec and quality options YouTube has made
  # available for the perticular video by printing videos.
  yt.list_formats
  
  #Video : H.264 (.mp4) - 720p
  #Video : VP8 (.webm) - 360p
  #Video : H.264 (.mp4) - 360p
  #Video : Sorenson H.263 (.flv) - 240p
  #Video : MPEG-4 Visual (.3gp) - 240p
  #Video : MPEG-4 Visual (.3gp) - 144p
  
  
  video = yt.get("mp4")
  
  # to select a video by a specific resolution and filetype you can use the get
  # method.
  
  video = yt.get('mp4', '720p')
  
  # gives instance of a new thread spawned which continues download in background 
  t = video.download()
  
  # call the join method on thread 
  # you need to do this inorder for the program to exit after the thread completes 
  # otherwise the program may exit first, this will be useful for looping and 
  # downloading multiple videos where multiple threads download simultaneously
  t.join
  
  # Note: If you wanted to choose the output directory, simply pass it as an
  # argument to the download method.
  video.download('/tmp/')
```  

##Thanks
NFicano [Github username]