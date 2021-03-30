//
//  UserDefaultsController.swift
//  DiscoverFlix
//
//  Created by Scott on 3/25/21.
//

import Foundation

final class UserDefaultsController: ObservableObject {
    static let shared = UserDefaultsController()
    
    @Published var movieVoteAverage: Double {
        didSet {
            UserDefaults.standard.set(movieVoteAverage, forKey: "movieVoteAvg")
        }
    }
    
    @Published var movieUrlString: String {
        didSet {
            UserDefaults.standard.set(movieUrlString, forKey: "movieUrl")
        }
    }
    
    @Published var movieTitle: String {
        didSet {
            UserDefaults.standard.set(movieTitle, forKey: "movieTitle")
        }
    }
    
    @Published var genreSelection: Int {
        didSet {
            UserDefaults.standard.set(genreSelection, forKey: "genre")
        }
    }
    @Published var email: String {
        didSet {
            UserDefaults.standard.set(email, forKey: "email")
        }
    }
    
    init() {
        self.movieVoteAverage = UserDefaults.standard.double(forKey: "movieVoteAvg")
        self.movieUrlString = UserDefaults.standard.string(forKey: "movieUrl") ?? ""
        self.movieTitle = UserDefaults.standard.string(forKey: "movieTitle") ?? ""
        self.genreSelection = UserDefaults.standard.integer(forKey: "genre")
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
}
