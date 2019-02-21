//
//  PhotoPetchOperation.swift
//  Astronomy
//
//  Created by Ilgar Ilyasov on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class PhotoFetchOperation: ConcurrentOperation {
    
    private var marsPhotoReference: MarsPhotoReference
    private var imageData: Data?
    private var task: URLSessionDataTask?
    
    init(marsRoverReference: MarsPhotoReference) {
        self.marsPhotoReference = marsRoverReference
        super.init()
    }
    
    override func start() {
        super.start()
        state = .isExecuting
        defer { self.state = .isFinished }
        
        guard let url = marsPhotoReference.imageURL.usingHTTPS else { return }
        
        task = URLSession.shared.dataTask(with: url) { (data, _, error) in
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
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
}
