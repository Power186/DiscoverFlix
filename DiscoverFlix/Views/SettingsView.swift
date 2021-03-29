//
//  SettingsView.swift
//  DiscoverFlix
//
//  Created by Scott on 3/19/21.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var userDefaultsController = UserDefaultsController()
    @State private var submit = false
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mode")) {
                    Picker("Mode", selection: $isDarkMode) {
                        Text("Light")
                            .font(.custom("Avenir", size: 18))
                            .fontWeight(.semibold)
                            .tag(false)
                        Text("Dark")
                            .font(.custom("Avenir", size: 18))
                            .fontWeight(.semibold)
                            .tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Picker(selection: $userDefaultsController.genreSelection, label: Text("Favorite Genre")) {
                    Text("Action").tag(1)
                    Text("Comedy").tag(2)
                    Text("Horror").tag(3)
                    Text("SciFy").tag(4)
                    Text("Romance").tag(5)
                    Text("Real Life").tag(6)
                }
                
                Section(header: Text("Email")) {
                    TextField("Email", text: $userDefaultsController.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Text("Save")
                            .font(.headline)
                    }
                    Spacer()
                }
                
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(false))
    }
}
