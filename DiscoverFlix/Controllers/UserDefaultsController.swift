//
//  UserDefaultsController.swift
//  DiscoverFlix
//
//  Created by Scott on 3/25/21.
//

import Foundation

final class UserDefaultsController: ObservableObject {
    static let shared = UserDefaultsController()
    
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
        self.genreSelection = UserDefaults.standard.integer(forKey: "genre")
        self.email = UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
}
