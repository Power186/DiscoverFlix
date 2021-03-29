//
//  Cast.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import Foundation

struct CastResponse: Codable {
    var cast: [Cast]
}

struct Cast: Codable, Identifiable {
    var id: Int?
    var name: String?
    var character: String?
    var profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}

extension Cast {
    var profilePhoto: String {
        if let path = profilePath {
            return "https://image.tmdb.org/t/p/original/\(path)"
        } else {
            return "https://picsum.photos/200/300"
        }
    }
}
