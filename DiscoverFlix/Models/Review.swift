//
//  Review.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import Foundation

struct ReviewResponse: Codable {
    var results: [Review]
}

struct Review: Codable, Identifiable {
    var id: String?
    var author: String?
    var content: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
    }
}
