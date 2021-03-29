//
//  HomeTabView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

struct HomeTabView: View {
    
    enum Tab: Int {
        case movie
        case discover
        case favorite
        case movieBuddies
    }
    
    @State private var selectedTab = Tab.movie
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesView().tabItem {
                tabBarItem(text: "Movies", image: "film")
            }
            .tag(Tab.movie)
            
            DiscoverView().tabItem {
                tabBarItem(text: "Discover", image: "square.stack")
            }
            .tag(Tab.discover)
            
            FavoritesView().tabItem {
                tabBarItem(text: "Watch", image: "star")
            }
            .tag(Tab.favorite)
            
            MovieBuddyView().tabItem {
                tabBarItem(text: "Movie Buddies", image: "person")
            }
            .tag(Tab.movieBuddies)
            
        }
        
    } // body
    
    private func tabBarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
