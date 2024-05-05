//
//  PostsViewModel.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import Foundation

class DisplayImagesViewModel {
    
    var postsArray = [Post]()
    // To determinae that there is no more data from web service

    //MARK: API Call
    func getPosts(completion: @escaping (Result<Posts, Error>) -> Void) {
        let endpoint = ServerParam.baseURL + "content/misc/media-coverages?limit=100"
        APIManager.shared.request(endpoint: endpoint, method: "GET", parameters: nil) { [weak self] (result: Result<Posts, Error>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let posts):
                self.postsArray = posts
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


