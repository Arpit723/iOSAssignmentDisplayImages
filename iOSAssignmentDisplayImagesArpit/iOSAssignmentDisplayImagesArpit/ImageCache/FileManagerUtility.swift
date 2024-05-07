//
//  FileManagerUtility.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 06/05/24.
//

import Foundation
import UIKit

public class FileManagerUtility {
    
    static func saveImagesInCacheDirectory(id: String, image: UIImage) {
        let fileManager = FileManager.default
        do {
            let cacheDirectory = try fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let folderURL = cacheDirectory.appendingPathComponent("Images")
            if !fileManager.fileExists(atPath: folderURL.absoluteString) {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            }
            let imageUrl = folderURL.appendingPathComponent("\(id).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                    try imageData.write(to: imageUrl)
                    print("Image saved in cache directory")
                }
        } catch {
           print("Error saving file in cache directory \(error)")
        }
    }
    
    static func getImagesFromCacheDirectory(id: String) -> UIImage? {

        let cacheDir = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let getImagePath = cacheDir.appendingPathComponent("Images").appendingPathComponent("\(id).jpg")
        if FileManager.default.fileExists(atPath: getImagePath.path) {
            return UIImage(contentsOfFile: getImagePath.path)
        } else {
            print("Could not get image in cache directory")
            return nil
        }
    }
    
}
