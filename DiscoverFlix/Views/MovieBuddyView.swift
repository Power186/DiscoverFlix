//
//  MovieBuddyView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/26/21.
//

import SwiftUI

struct MovieBuddyView: View {
    @Environment(\.managedObjectContext) var moc
    @State private var showContacts = false
    
    @FetchRequest(entity: Buddy.entity(),
                  sortDescriptors: [])
    var buddies: FetchedResults<Buddy>
    
    var body: some View {
        VStack {
            List {
                ForEach(buddies, id: \.self) { buddy in
                    NavigationLink(destination: MovieBuddyDetailView(buddy: buddy)) {
                        
                        HStack(spacing: 10) {
                            Image(systemName: "person")
                                .imageScale(.medium)
                            Text("\(buddy.name ?? "")")
                        }
                        
                    }
                }
                .onDelete(perform: deleteBuddies(at:))
            }
            .listStyle(GroupedListStyle())
            
            addBuddyButton
                .padding(.bottom, 16)
            
        }
        .fullScreenCover(isPresented: $showContacts, content: {
            ContactPicker()
        })
        
    } // body
    
    private var addBuddyButton: some View {
        Button(action: {
            showContacts.toggle()
        }) {
            Image(systemName: "plus.circle")
                .imageScale(.large)
            Text("Buddy")
                .font(.headline)
        }
    }
    
    private func deleteBuddies(at offsets: IndexSet) {
        for index in offsets {
            let buddy = buddies[index]
            moc.delete(buddy)
            PersistenceController.shared.save()
        }
    }
    
} // struct
