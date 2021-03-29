//
//  Movie.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import Foundation

struct MovieResponse: Codable {
    var results: [Movie]
}

struct Movie: Codable, Identifiable {
    var id: Int?
    var title: String?
    var originalLanguage: String?
    var overview: String?
    var posterPath: String?
    var backdropPath: String?
    var popularity: Double?
    var voteAverage: Double?
    var voteCount: Int?
    var video: Bool?
    var adult: Bool?
    var releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalLanguage = "original_language"
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case video
        case adult
        case releaseDate = "release_date"
    }
}

extension Movie {
    var posterPathString: String {
        if let path = posterPath {
            return "https://image.tmdb.org/t/p/original/\(path)"
        } else {
            return ""
        }
    }
    
    var votingAverage: Double {
        if let avg = voteAverage {
            return avg / 10.0
        } else {
            return 0.0
        }
    }
    
    var titleWithLanguage: String {
        guard let title = title,
              let lang = originalLanguage else { return "" }
        return "\(title) (\(lang))"
    }
}
