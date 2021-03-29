//
//  MovieCell.swift
//  DiscoverFlix
//
//  Created by Scott on 3/23/21.
//

import SwiftUI

struct MovieCell: View {
    var movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            moviePoster
            
            VStack(alignment: .leading, spacing: 0) {
                movieTitle
                
                HStack {
                    movieVotes
                    movieReleaseDate
                }
                
                movieOverview
            }
        }
    }
    
    private var moviePoster: some View {
        AsyncImage(url: URL(string: movie.posterPathString)!) {
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.4))
        } image: { (img) -> Image in
            Image(uiImage: img)
                .resizable()
        }
        .frame(width: 100, height: 160)
        .animation(.easeInOut(duration: 0.5))
        .transition(.opacity)
        .scaledToFill()
        .cornerRadius(15)
        .shadow(radius: 15)
    }
    
    private var movieTitle: some View {
        Text(movie.titleWithLanguage)
            .font(.system(size: 17))
            .bold()
            .foregroundColor(.purple)
    }
    
    private var movieVotes: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(movie.votingAverage))
                .stroke(Color.blue, lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            Circle()
                .trim(from: 0, to: 1)
                .stroke(Color.blue.opacity(0.2), lineWidth: 4)
                .frame(width: 50)
                .rotationEffect(.degrees(-90))
            
            Text(String.init(format: "%0.2f", movie.voteAverage ?? 0.0))
                .foregroundColor(.blue)
                .font(.subheadline)
                .bold()
        }
        .frame(height: 80)
    }
    
    private var movieReleaseDate: some View {
        Text(movie.releaseDate ?? "")
            .foregroundColor(.primary)
            .font(.subheadline)
    }
    
    private var movieOverview: some View {
        Text(movie.overview ?? "")
            .font(.body)
            .foregroundColor(.gray)
    }
    
}

struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieCell(movie: Movie(id: 0, title: "The Big One", originalLanguage: "English", overview: "Stuff goes on and then more stuff goes on and its crazy", posterPath: "", backdropPath: "", popularity: 8.7, voteAverage: 5.6, voteCount: 5, video: false, adult: false, releaseDate: "2021-11-25"))
    }
}
