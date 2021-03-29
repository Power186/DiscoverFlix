//
//  MovieDetailView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/23/21.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var loader: ImageLoader
    @ObservedObject private var movieManager = MovieDownloadManager()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.openURL) var openURL
    
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: movie.posterPathString)!, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading) {
                    headerView
                    moviePosterView
                    movieOverView
                    reviewLink
                    castInfo
                    Spacer()
                }
                .padding(.top, 84)
                .padding(.horizontal, 32)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var backgroundView: some View {
        imageView
            .onAppear(perform: {
                loader.load()
            })
            .blur(radius: 100)
            .foregroundColor(Color.gray.opacity(0.75))
    }
    
    private var imageView: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!)
                    .resizable()
            } else {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.4))
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            Text(movie.titleWithLanguage)
                .font(.title)
                .foregroundColor(.purple)
            
            Text("Release Date: \(movie.releaseDate ?? "-")")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
    
    private var moviePosterView: some View {
        HStack(alignment: .center) {
            Spacer()
            imageView
                .frame(width: 200, height: 320)
                .cornerRadius(20)
                .onTapGesture {
                    let key = movieManager.trailers[0].key ?? ""
                    guard let trailerUrl = URL(string: "https://www.youtube.com/watch?v=\(key)") else { return }
                    openURL(trailerUrl)
                }
                .onAppear(perform: {
                    movieManager.getMovieTrailers(for: movie)
                })
            Spacer()
        }
    }
    
    private var movieOverView: some View {
        Text(movie.overview ?? "-")
            .font(.body)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 16)
    }
    
    private var reviewLink: some View {
        HStack {
            Divider()
            NavigationLink(destination: MovieReviewView(movie: movie)) {
                HStack {
                    Image(systemName: "list.star")
                        .imageScale(.medium)
                        .foregroundColor(.blue)
                    
                    Text("Reviews")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            
            // Favorite button
            
            Button(action: {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                
                let favorite = Favorite(context: managedObjectContext)
                favorite.titleWithLanguage = movie.titleWithLanguage
                favorite.voteAverage = movie.voteAverage ?? 0.0
                favorite.votingAverage = movie.votingAverage
                
                let key = movieManager.trailers[0].key ?? ""
                let movieUrlString = "https://www.youtube.com/watch?v=\(key)"
                favorite.trailerUrlString = movieUrlString
                PersistenceController.shared.save()
                
            }) {
                Image(systemName: "plus")
                    .imageScale(.medium)
                    .foregroundColor(.blue)
                Text("Favorite")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            
            Divider()
        }
    }
    
    private var castInfo: some View {
        VStack(alignment: .leading) {
            Text("CAST")
                .foregroundColor(.primary)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(movieManager.cast) { cast in
                        VStack {
                            AsyncImage(url: URL(string: cast.profilePhoto)!) {
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
                            
                            Text("\(cast.name ?? "-") as \(cast.character ?? "-")")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 100)
                                .fixedSize(horizontal: false, vertical: true)

                        }
                    }
                }
            }
        }
        .onAppear(perform: {
            movieManager.getCast(for: movie)
        })
    }
    
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: Movie(id: 0, title: "The Whale Gang", originalLanguage: "en", overview: "This stuff happened agian and again and then some more", posterPath: "", backdropPath: "", popularity: 7.6, voteAverage: 7.6, voteCount: 34, video: false, adult: true, releaseDate: "2020-01-09"))
    }
}
