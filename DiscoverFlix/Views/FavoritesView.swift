//
//  FavoritesView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/24/21.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.openURL) var openURL
    
    @FetchRequest(entity: Favorite.entity(),
                  sortDescriptors: [])
    var favorites: FetchedResults<Favorite>
    
    var body: some View {
        
        List {
            ForEach(favorites, id: \.self) { favorite in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .trim(from: 0, to: CGFloat(favorite.votingAverage))
                            .stroke(Color.blue, lineWidth: 4)
                            .frame(width: 50)
                            .rotationEffect(.degrees(-90))
                        Circle()
                            .trim(from: 0, to: 1)
                            .stroke(Color.blue.opacity(0.2), lineWidth: 4)
                            .frame(width: 50)
                            .rotationEffect(.degrees(-90))
                        
                        Text(String.init(format: "%0.2f", favorite.voteAverage ))
                            .foregroundColor(.blue)
                            .font(.subheadline)
                            .bold()
                    }
                    .frame(height: 80)

                    Text(favorite.titleWithLanguage ?? "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        guard let trailerUrl = URL(string: favorite.trailerUrlString ?? "") else { return }
                        openURL(trailerUrl)
                        
                    }) {
                        Image(systemName: "play.tv")
                            .imageScale(.medium)
                            .foregroundColor(.green)
                    }
                    
                }
            }
            .onDelete(perform: deleteFavorites(at:))
        }
        .listStyle(GroupedListStyle())
        .navigationBarItems(leading: EditButton())
    }
    
    private func deleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let favorite = favorites[index]
            moc.delete(favorite)
            PersistenceController.shared.save()
        }
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    
    static var previews: some View {
        FavoritesView()
    }
}
