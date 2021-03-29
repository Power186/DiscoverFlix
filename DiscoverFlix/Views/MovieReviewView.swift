//
//  MovieReviewView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/24/21.
//

import SwiftUI

struct MovieReviewView: View {
    @ObservedObject var movieReviewManager: MovieReviewManager
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        self.movieReviewManager = MovieReviewManager(movie: movie)
        
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.7)
            
            List {
                ForEach(movieReviewManager.reviews) { review in
                    VStack(alignment: .leading) {
                        Text(review.author ?? "")
                            .font(.title3)
                            .bold()
                        Text(review.content ?? "")
                            .font(.body)
                            .lineLimit(nil)
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color.clear)
                }
            }
            .onAppear(perform: {
                movieReviewManager.getMovieReviews()
            })
            .padding(.horizontal, 32)
        }
        .edgesIgnoringSafeArea(.all)
        
    }
    
}
