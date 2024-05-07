//
//  ImagesCollectionViewCell.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 05/05/24.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgvImage: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var currentPost: Post?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            self.imgvImage.layer.cornerRadius = 8.0
            self.imgvImage.layer.borderColor = UIColor.gray.cgColor
            self.imgvImage.layer.borderWidth = 2.0
            self.imgvImage.layer.masksToBounds = true
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
    }
    
  
    func loadImage(from post: Post) {
        self.cancelImageLoad()

        self.currentPost = post
        let urlString = post.thumbnail.domain + "/" + post.thumbnail.basePath + "/0/" + post.thumbnail.key.rawValue
        guard let url = URL(string: urlString) else {
            return
        }
        self.activityIndicator.startAnimating()
        ImageDownLoader.shared.loadImages(id: post.id,url: url, completion: { image in
            DispatchQueue.main.async {
                self.imgvImage.image = image
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    func cancelImageLoad() {
        guard let post = self.currentPost else {
            print("Current post not found to cancel")
            return
        }
        let block = ImageDownLoader.shared.blocksDictionary[post.id]
        block?.cancel()
        ImageDownLoader.shared.blocksDictionary[post.id] = nil
        self.imgvImage.image = UIImage(named: "placeholder")
    }
}
