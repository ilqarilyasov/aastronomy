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
    var imageData: Data?
    private var task: URLSessionDataTask?
    
    init(marsRoverReference: MarsPhotoReference) {
        self.marsPhotoReference = marsRoverReference
        super.init()
    }
    
    override func start() {
        super.start()
        state = .isExecuting
        guard let url = marsPhotoReference.imageURL.usingHTTPS else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
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
        dataTask.resume()
        task = dataTask
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
}
