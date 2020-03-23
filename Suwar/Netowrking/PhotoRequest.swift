//
//  PhotoRequest.swift
//  Suwar
//
//  Created by Ilyasa Azmi on 22/03/20.
//  Copyright © 2020 Ilyasa Azmi. All rights reserved.
//

import Foundation

enum PhotoError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct PhotoRequest {
    let resourceUrl: URL
    let API_KEY = "s3TS88UbAa514k1hqwV4LBdB5qe02n6u3qDSafOszRM"
    
    init(searchInput: String) {
        let resourceString = "https://api.unsplash.com/search/photos?page=1&query=\(searchInput)&client_id=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceUrl = resourceURL
    }
    
    func getPhotos (completion: @escaping(Result<[PhotoDetail], PhotoError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceUrl) {data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photoResults = try decoder.decode(PhotoResults.self, from: jsonData)
                let photoDetails = photoResults.results
                
                print(photoDetails)
                completion(.success(photoDetails))
            } catch {
                completion(.failure(.canNotProcessData))
                print(error)
            }
        }
        dataTask.resume()
    }
}




