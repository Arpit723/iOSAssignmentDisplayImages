# iOSAssignmentDisplayImages

**1. Cache mechanism
**
if you don't find image in memery cache (NSCache), you can then look in your caches directory, and if you don't find it there you can download it.

**1.1 Downloading and caching
**
if look image in memory cache
   found then to load iamge 
else if look image in cache directory
   found then to load image from there
   save image in memory cache
else 
   download image
   save image in memory cache
   save image in cache directory

**2 Display images
**
2.1
Before loading next images, cancelling previous image loading.
Load current image asynchronously.

2.2
Implement collection view prefectching data source method, to prefetch data from api/cache before cell loads.

**3. Reachability check
**  
Checking reachability before getPosts api call, if internet not available alert is shown
Checking reachability if any image is load from api, shown error placeholder images 

**4. General error loading images
**
Shown error placeholder if any image is loadeding error
