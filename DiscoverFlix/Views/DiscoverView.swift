//
//  DiscoverView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

struct DiscoverView: View {
    @State private var offset: CGFloat = 0
    @State private var index = 0
    @State private var showDetails = false
    
    @ObservedObject private var movieManager = MovieDownloadManager()
    let spacing: CGFloat = 10
    
    var body: some View {
        
        GeometryReader { geo in
            return ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: spacing) {
                    ForEach(movieManager.movies) { movie in
                        movieCard(movie: movie)
                            .frame(width: geo.size.width)
                    }
                }
            }
            .content.offset(x: self.offset)
            .frame(width: geo.size.width, alignment: .leading)
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        self.offset = value.translation.width - geo.size.width * CGFloat(index)
                    })
                    .onEnded({ value in
                        if -value.predictedEndTranslation.width > geo.size.width / 2, index < movieManager.movies.count {
                            index += 1
                        }
                        if value.predictedEndTranslation.width > geo.size.width / 2, index > 0 {
                            index -= 1
                        }
                        withAnimation {
                            offset = -(geo.size.width + spacing) * CGFloat(index)
                        }
                    })
            )
        }
        .onAppear(perform: {
            movieManager.getPopular()
        })
        
    }
    
    private func movieCard(movie: Movie) -> some View {
        ZStack(alignment: .bottom) {
            poster(movie: movie)
            detailView(movie: movie)
        }
        .shadow(radius: 12)
        .cornerRadius(12)
    }
    
    private func poster(movie: Movie) -> some View {
        AsyncImage(url: URL(string: movie.posterPathString)!) {
            Rectangle()
                .foregroundColor(Color.black.opacity(0.4))
        } image: { (img) -> Image in
            Image(uiImage: img)
                .resizable()
        }
        .animation(.easeInOut(duration: 0.5))
        .transition(.scale)
        .scaledToFill()
        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.75, alignment: .center)
        .cornerRadius(20)
        .shadow(radius: 15)
        .overlay(
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.clear, .primary]), startPoint: .center, endPoint: .bottom))
                .clipped()
        )
        .cornerRadius(12)
    }
    
    private func detailView(movie: Movie) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading) {
                Text(movie.titleWithLanguage)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top)

                Text(movie.overview ?? "")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.top)
                
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    Text("Details")
                        .bold()
                        .padding()
                        .foregroundColor(Color.primary)
                        .background(Color.blue.opacity(0.75))
                        .cornerRadius(12)
                }
                .padding()
                
            }
            .background(Color.white.opacity(0.6))
            .cornerRadius(12)
            .lineLimit(5)
        }
        .padding()
    }
    
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
