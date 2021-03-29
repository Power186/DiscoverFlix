//
//  MoviesView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

struct MoviesView: View {
    @State private var searchTerm = ""
    @State private var selectionIndex = 0
    @State private var tabs = ["Now Playing", "Upcoming", "Trending"]
    
    @ObservedObject var movieManager = MovieDownloadManager()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectionStyle = .default
        
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().tintColor = .gray
        UINavigationBar.appearance().barTintColor = .purple
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.purple]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.purple]
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                selectionTitle
                searchBarView
            }
            .padding(.horizontal)
            
            segmentedControlView
            
            List {
                ForEach(movieManager.movies.filter { searchTerm.isEmpty ? true : $0.title?.lowercased().localizedStandardContains(searchTerm.lowercased()) ?? true }) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieCell(movie: movie)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .onAppear(perform: {
                movieManager.getNowPlaying()
            })
            Spacer()
        }
    }
    
    private var selectionTitle: some View {
        Text(tabs[selectionIndex])
            .font(.title)
            .foregroundColor(.blue)
            .padding(.top)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.medium)
            
            TextField("Search..", text: $searchTerm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: { searchTerm = "" }) {
                Image(systemName: "xmark.circle")
                    .imageScale(.medium)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var segmentedControlView: some View {
        VStack {
            Picker("_", selection: $selectionIndex) {
                ForEach(0..<tabs.count) { index in
                    Text(tabs[index])
                        .font(.title)
                        .bold()
                        .tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.blue.opacity(0.25))
            .onChange(of: selectionIndex, perform: { _ in
                if selectionIndex == 0 {
                    movieManager.getNowPlaying()
                } else if selectionIndex == 1 {
                    movieManager.getUpcoming()
                } else if selectionIndex == 2 {
                    movieManager.getPopular()
                }
            })
        }.padding()
    }
    
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
