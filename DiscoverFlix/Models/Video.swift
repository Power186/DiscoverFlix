//
//  Video.swift
//  DiscoverFlix
//
//  Created by Scott on 3/24/21.
//

import Foundation

struct Videos: Codable {
    var results: [Video]
}

struct Video: Codable {
    var key: String?
}
