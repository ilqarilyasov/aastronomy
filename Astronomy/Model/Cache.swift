//
//  Cache.swift
//  Astronomy
//
//  Created by Ilgar Ilyasov on 2/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private let queue = DispatchQueue(label: "com.LambdaScool.Astronomy.CacheQueue")
    private var cachedItems = [Key: Value]()
    
    func cache(value: Value, forKey: Key) {
        queue.async {
            self.cachedItems[forKey] = value
        }
    }
    
    func value(forKey: Key) -> Value? {
        return queue.sync {
            cachedItems[forKey]
        }
    }
}
