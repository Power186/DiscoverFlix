//
//  ImageCache.swift
//  DiscoverFlix
//
//  Created by Scott on 3/22/21.
//

import UIKit

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TempImageCache: ImageCache {
    
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 700
        cache.totalCostLimit = 1024 * 1024 * 700
        return cache
    }()
    
    subscript(_ url: URL) -> UIImage? {
        get {
            cache.object(forKey: url as NSURL )
        }
        set {
            newValue == nil ? cache.removeObject(forKey: url as NSURL) : cache.setObject(newValue!, forKey: url as NSURL)
        }
    }
    
}
