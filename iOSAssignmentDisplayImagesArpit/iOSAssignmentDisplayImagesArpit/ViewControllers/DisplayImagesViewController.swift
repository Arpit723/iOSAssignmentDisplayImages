//
//  ViewController.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 05/05/24.
//

import UIKit

class DisplayImagesViewController: UIViewController {

    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private let refreshControl = UIRefreshControl()
    private let viewModel = DisplayImagesViewModel()

    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images"
        self.setUpCollectionView()
        // Do any additional setup after loading the view.

        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.refresh()
        })
    }
    
    func setUpCollectionView() {
        collectionViewImages.register(UINib(nibName: "ImagesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImagesCollectionViewCell")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.collectionViewImages.refreshControl = refreshControl
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let itemSize = (UIScreen.main.bounds.width - 50)/3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        collectionViewImages!.collectionViewLayout = layout
    }


}

//MARK: Collection View Delegate and Data Source

extension DisplayImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel.postsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ImagesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        let post = self.viewModel.postsArray[indexPath.row]
        cell.loadImage(from: post)
        return cell
    }
    
    
   
}
// MARK: UICollectionViewDataSourcePrefetching

extension DisplayImagesViewController : UICollectionViewDataSourcePrefetching {
    

    /// - Tag: Prefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function)
        // Begin asynchronously fetching data for the requested index paths.
        for indexPath in indexPaths {
            print("IndexPath \(indexPath.item)")
            let post = self.viewModel.postsArray[indexPath.row]
            let urlString = post.thumbnail.domain + "/" + post.thumbnail.basePath + "/0/" + post.thumbnail.key.rawValue
            guard let url = URL(string: urlString) else {
                return
            }
            ImageDownLoader.shared.loadImages(id: post.id, url:url , completion: {image in})
        }
    }

    /// - Tag: CancelPrefetching
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // Cancel any in-flight requests for data for the specified index paths.
        print(#function)
        for indexPath in indexPaths {
            print("IndexPath \(indexPath.item)")
            let post = self.viewModel.postsArray[indexPath.row]
            let block = ImageDownLoader.shared.blocksDictionary[post.id]
            block?.cancel()
        }
    }
}
//MARK: API Call

extension DisplayImagesViewController {
    
    
    @objc func refresh() {
        self.apiCallToGetPosts()
    }
    
    func apiCallToGetPosts() {
        if !appDelegate.isConnectedToInternet {
            Utility.showAlert(title: "Error", message: "Please connect to internet.")
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            return
        }
        viewModel.getPosts(completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                self.activityIndicator.stopAnimating()
                self.refreshControl.endRefreshing()
                switch result {
                case .success(let posts):
                   // self.refreshControl.endRefreshing()
                    self.updateUI(posts: posts)
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                }
            }
            
        })
    }
    
    func updateUI(posts: [Post]) {
        print("Posts count \(posts.count)")
        self.collectionViewImages.reloadData()
    }
}
