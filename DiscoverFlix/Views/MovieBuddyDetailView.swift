//
//  MovieBuddyDetailView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/26/21.
//

import SwiftUI

struct MovieBuddyDetailView: View {
    @Environment(\.openURL) var openURL
    
    @FetchRequest(entity: Favorite.entity(),
                  sortDescriptors: [])
    var favorites: FetchedResults<Favorite>
    
    @State private var movieTitle = ""
    @State private var movieTrailerUrlString = ""
    @State private var movieVoteAverage: Double = 0
    
    @State private var showEvent = false
    @State private var movieSelection = 0
//    let person: Person
    let buddy: Buddy
    
    var body: some View {
        Form {
            Picker(selection: $movieSelection, label: Text("Movie Selection")) {
                ForEach(0..<favorites.count, id: \.self) { favorite in
                    Text("\(favorites[favorite].titleWithLanguage ?? "")")
                        .onAppear(perform: {
                            let title = favorites[favorite].titleWithLanguage ?? ""
                            movieTitle = title
                            
                            let trailerUrlString = favorites[favorite].trailerUrlString ?? ""
                            movieTrailerUrlString = trailerUrlString
                            
                            let voteAverage = favorites[favorite].voteAverage
                            movieVoteAverage = voteAverage
                        })
                }
            }
            
            Section(header: Text("Schedule Movie").bold().italic()) {
                HStack {
                    Spacer()
                    Button(action: {
                        showEvent.toggle()
                    }) {
                        Image(systemName: "calendar.badge.clock")
                            .imageScale(.large)
                    }
                    Spacer()
                }
            }
            
            Section(header: Text("Name").bold().italic()) {
                Text("\(buddy.name ?? "")")
            }
            
            HStack {
                Spacer()
                Circle()
                    .frame(width: 125, height: 125)
                    .overlay(
                        Image(systemName: "person")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                )
                Spacer()
            }
            
            Section(header: Text("Phone").bold().italic()) {
                HStack(spacing: 10) {
                    phoneButton
                    Text(buddy.phone ?? "")
                }
            }
            
            Section(header: Text("Email").bold().italic()) {
                Text("\(buddy.email ?? "")")
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEvent, content: {
            EventView(movieTitle: $movieTitle,
                      movieUrlString: $movieTrailerUrlString,
                      movieVoteAverage: $movieVoteAverage)
        })
        
    }
    
    private var phoneButton: some View {
        Button(action: {
            openURL(phoneUrl())
        }) {
            Image(systemName: "phone.fill")
                .imageScale(.large)
        }
    }
    
    private func phoneUrl() -> URL {
        let phoneString = "tel://\(buddy.phone ?? "")"
        let replacedDash = phoneString.replacingOccurrences(of: "-", with: "")
        let replacedParenth = replacedDash.replacingOccurrences(of: "(", with: "")
        let replacedOtherParenth = replacedParenth.replacingOccurrences(of: ")", with: "")
        let replacedSpacing = replacedOtherParenth.replacingOccurrences(of: " ", with: "")
        
        guard let number = URL(string: replacedSpacing) else { return URL(string: "")! }
        return number
    }
    
}
