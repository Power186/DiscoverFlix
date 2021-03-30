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
    
    @ObservedObject var userSettings = UserDefaultsController()
    
    @State private var phoneNumber = ""
    @State private var showEvent = false
    @State private var movieSelection = 0
    @State private var showMessage = false
//    let person: Person
    let buddy: Buddy
    
    var body: some View {
        Form {
            Picker(selection: $movieSelection, label: Text("Movie Selection")) {
                ForEach(0..<favorites.count, id: \.self) { favorite in
                    Text("\(favorites[favorite].titleWithLanguage ?? "")")
                        .onAppear(perform: {
                            let title = favorites[favorite].titleWithLanguage ?? ""
                            userSettings.movieTitle = title
                            
                            let trailerUrlString = favorites[favorite].trailerUrlString ?? ""
                            userSettings.movieUrlString = trailerUrlString
                            
                            let voteAverage = favorites[favorite].voteAverage
                            userSettings.movieVoteAverage = voteAverage
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
            
            Section(header: Text("Call").bold().italic()) {
                HStack(spacing: 10) {
                    callButton
                    Text(buddy.phone ?? "")
                }
            }
            
            Section(header: Text("Message").bold().italic()) {
                HStack(spacing: 10) {
                    messageButton
                    Text(buddy.phone ?? "")
                }
            }
            
            Section(header: Text("Email").bold().italic()) {
                Text("\(buddy.email ?? "")")
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEvent, content: {
            EventView()
        })
        
    }
    
    private var messageButton: some View {
        Button(action: {
            showMessage.toggle()
        }) {
            Image(systemName: "message.fill")
                .imageScale(.large)
        }
        .onAppear(perform: {
            phoneNumber = buddy.phone ?? ""
        })
        .sheet(isPresented: $showMessage, content: {
            MessageView(phoneNumber: $phoneNumber)
        })
    }
    
    private var callButton: some View {
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
