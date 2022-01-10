//
//  ContentView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @AppStorage("sortValue", store: .standard) var sortValue = "recent"
    @AppStorage("filterValue", store: .standard) var filterValue = "none"

    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Favourites")
                        .font(.system(.largeTitle, design: .default))
                        .fontWeight(.heavy)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Menu {
                        Text("Sort By")
                        Picker(selection: $sortValue, label: Text("sort")) {
                            Text("Recently Added").tag("recent")
                            Text("Name").tag("name")
                            Text("Team").tag("team")
                        }
                    } label: {
                        Image(systemName: sortValue == "recent" ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                    } //: MENU
                    
                    Menu {
                        Text("Filter By Team")
                        Picker(selection: $filterValue, label: Text("filter")) {
                            Text("None").tag("none")
                            
                            ForEach(allTeams, id: \.self) { team in
                                Text(team).tag(team)
                            }
                        }
                    } label: {
                        Image(systemName: filterValue == "none" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                    } //: MENU
                } //: HSTACK
                .padding(.horizontal, 15)
                
                Spacer()
                
                FavouritesList(sortValue: sortValue, filterValue: filterValue)
            } //: VSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = .clear
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical, 10)
            .background(
                backgroundGradient.ignoresSafeArea()
            )
            .navigationBarTitle("Favourites", displayMode: .large)
            .navigationBarHidden(true)
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
