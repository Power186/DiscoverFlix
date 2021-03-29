//
//  ContentView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    
    var body: some View {
        NavigationView {
            Group {
                HomeTabView()
            }
            .navigationBarTitle("DiscoverFlix", displayMode: .inline)
            .navigationBarItems(trailing: settingsButton)
            .sheet(isPresented: $showSettings, content: {
                SettingsView(isPresented: $showSettings)
            })
        }
        
    } // body
    
    private var settingsButton: some View {
        Button(action: {
            showSettings.toggle()
        }) {
            Image(systemName: "gear")
                .imageScale(.large)
                .foregroundColor(.gray)
        }
    }
    
} // struct

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
