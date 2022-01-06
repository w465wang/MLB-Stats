//
//  MainView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle")
                    Text("Search")
                }
            
            ContentView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favourites")
                }
        } //: TAB
        .onAppear() {
            UITabBar.appearance().backgroundColor = .secondarySystemBackground
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .preferredColorScheme(.dark)
        }
    }
}
