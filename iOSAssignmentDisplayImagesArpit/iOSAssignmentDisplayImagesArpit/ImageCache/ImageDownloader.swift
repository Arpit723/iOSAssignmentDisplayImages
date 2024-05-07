//
//  ImageDownloader.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 06/05/24.
//

import Foundation
import UIKit

final class ImageDownLoader {
    
    static let shared = ImageDownLoader()
    private let cache = Cache<String, UIImage>()
    var blocksDictionary = [String: DispatchWorkItem]()
    
    func loadImages(id: String, url: URL, completion: @escaping ((UIImage?) -> Void)) {
        

        if let cached = self.cache[id] {
            print("Image loaded from memory cache")
            completion(cached)
            return
        } else if let image = FileManagerUtility.getImagesFromCacheDirectory(id: id) {
            print("Image loaded from cache directory")
            print("Image saved to memery cache")
            completion(image)
            self.cache[id] = image
            return
        } else {
            
            guard appDelegate.isConnectedToInternet else {
                    print("unable to connect to internet")
                    completion(UIImage(named: "warning-icon"))
                    return
            }
            let dispatchWorkItem = DispatchWorkItem(block: {

                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    guard let self = self else {
                        return
                    }
                    if let error {
                        if (error as? URLError)?.code == .cancelled {
                            completion(UIImage(named: "warning-icon"))
                            return
                        }
                        print("unable to load downloaded image \(error.localizedDescription)")
                        completion(UIImage(named: "warning-icon"))
                        return
                    }
                    guard let data, let downloadedImage = UIImage(data: data) else {
                        print("unable to load downloaded image")
                        completion(UIImage(named: "warning-icon"))
                        return
                    }
                    print("Image downloaded.")
                    print("Image saved to memory cache")
                    self.cache[id] = downloadedImage
                    FileManagerUtility.saveImagesInCacheDirectory(id: id, image: downloadedImage)
                    completion(downloadedImage)
                }
                task.resume()
            })
            self.blocksDictionary[id] = dispatchWorkItem
            DispatchQueue.main.async(execute: dispatchWorkItem)
        }

        } // else ends here
}
