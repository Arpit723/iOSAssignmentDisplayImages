//
//  ViewController.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 05/05/24.
//

import UIKit

class DisplayImagesViewController: UIViewController {

    let viewModel = DisplayImagesViewModel()

    @IBOutlet weak var collectionViewImages: UICollectionView!
    //MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images"
        self.setUpCollectionView()
        // Do any additional setup after loading the view.
        self.refresh()
    }
    
    func setUpCollectionView() {
        collectionViewImages.register(UINib(nibName: "ImagesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ImagesCollectionViewCell")

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
//MARK: API Call

extension DisplayImagesViewController {
    
    
    @objc func refresh() {
        self.apiCallToGetPosts()
    }
    
    func apiCallToGetPosts() {
        viewModel.getPosts(completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
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
