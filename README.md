# iOSAssignmentDisplayImages

* Cache mechanism

if you don't find image in memery cache (NSCache), you can then look in your caches directory, and if you don't find it there you can download it.

if look image in memory cache
   found then to load iamge 
else if look image in cache directory
   found then to load image from there
   save image in memory cache
else 
   download image
   save image in memory cache
   save image in cache directory
   
