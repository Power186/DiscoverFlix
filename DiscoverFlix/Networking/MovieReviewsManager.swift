//
//  MovieReviewsManager.swift
//  DiscoverFlix
//
//  Created by Scott on 3/22/21.
//

import SwiftUI

final class MovieReviewManager: ObservableObject {
    @Published var reviews = [Review]()
    
    private var movie: Movie
    static var baseURL = "https://api.themoviedb.org/3/movie/"
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func getMovieReviews() {
        getReviews(for: movie)
    }
    
    private func getReviews(for movie: Movie) {
        let urlString = "\(Self.baseURL)\(movie.id ?? 100)/reviews?api_key=\(API.key)"
        NetworkManager<ReviewResponse>.fetch(from: urlString) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.reviews = response.results
            case .failure(let error):
                self?.displayError(error, title: "Failed to get reviews.")
            }
        }
    }
    
    private func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    
}
