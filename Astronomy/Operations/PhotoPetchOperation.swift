//
//  PhotoPetchOperation.swift
//  Astronomy
//
//  Created by Ilgar Ilyasov on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {
    
    private let marsPhotoReference: MarsPhotoReference
    private var dataTask: URLSessionDataTask?
    var imageData: Data?
    
    init(marsRoverReference: MarsPhotoReference) {
        self.marsPhotoReference = marsRoverReference
        super.init()
    }
    
    override func start() {
        state = .isExecuting
        guard let url = marsPhotoReference.imageURL.usingHTTPS else { return }
        
        let urlCache = URLCache(memoryCapacity: Int(100e6), diskCapacity: Int(1e9), diskPath: nil) // Provide a disk path
        //        URLCache.shared = urlCache
        let session = URLSession.shared
        session.configuration.urlCache = urlCache
        
        dataTask = session.dataTask(with: url) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            
            if let error = error {
                NSLog("Error performing data task for PhotoFetchOperation: \(error)")
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task for: \(url)")
                return
            }
            
            self.imageData = data
        }
        
        dataTask?.resume()
    }
    
    override func cancel() {
        super.cancel()
        dataTask?.cancel()
    }
    
}
