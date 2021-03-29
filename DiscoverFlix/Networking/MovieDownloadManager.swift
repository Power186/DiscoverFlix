//
//  MovieDownloadManager.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

final class MovieDownloadManager: ObservableObject {
    @Published var movies = [Movie]()
    @Published var cast = [Cast]()
    @Published var trailers = [Video]()
    
    static var baseURL = "https://api.themoviedb.org/3/movie/"
    
    func getNowPlaying() {
        getMovies(movieUrl: .nowPlaying)
    }
    
    func getUpcoming() {
        getMovies(movieUrl: .upcoming)
    }
    
    func getPopular() {
        getMovies(movieUrl: .popular)
    }
    
    func getMovieTrailers(for movie: Movie) {
        let trailerUrlString = "\(Self.baseURL)\(movie.id ?? 0)/videos?api_key=\(API.key)&language=en-US"
        NetworkManager<Videos>.fetch(from: trailerUrlString) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.trailers = response.results
            case .failure(let error):
                self?.displayError(error, title: "Failed to get trailer.")
            }
        }
        
    }
    
    func getCast(for movie: Movie) {
        let urlString = "\(Self.baseURL)\(movie.id ?? 100)/credits?api_key=\(API.key)&language=en-US"
        NetworkManager<CastResponse>.fetch(from: urlString) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.cast = response.cast
            case .failure(let error):
                self?.displayError(error, title: "Failed to get cast.")
            }
        }
    }
    
    private func getMovies(movieUrl: MovieURL) {
        NetworkManager<MovieResponse>.fetch(from: movieUrl.urlString) { [weak self] (result) in
            switch result {
            case .success(let movieResponse):
                self?.movies = movieResponse.results
            case .failure(let error):
                self?.displayError(error, title: "Failed to get movies.")
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
