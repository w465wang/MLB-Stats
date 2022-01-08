//
//  SearchView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

struct SearchView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var text: String = ""
    @State private var searchResults: [Player] = []
    @State private var selection: String = "Y"
    
    // MARK: - FUNCTIONS
    
    private func searchTask() {
        Task {
            do {
                let results = try await getSearchResults(active: selection, query: text)
                searchResults = results
            } catch {
                print("Error", error)
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack {
                HStack() {
                    Text("Search")
                        .font(.system(.largeTitle, design: .default))
                        .fontWeight(.heavy)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Menu {
                        Picker(selection: $selection, label: Text("Players")) {
                            Text("Active").tag("Y")
                            Text("Inactive/Historic").tag("N")
                            Text("All").tag("A")
                        }
                        .onChange(of: selection) { new in
                            searchTask()
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                    }
                } //: HSTACK
                .padding(.horizontal, 15)
                
                HStack {
                    TextField("e.g. Mike Trout", text: $text)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .padding()
                        .background(
                            Color(.secondarySystemBackground)
                        )
                        .cornerRadius(10)
                        .frame(maxWidth: 640)
                        .onSubmit {
                            searchTask()
                        }
                    
                    Spacer()
                    
                    Button(action: {
                        searchTask()
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                            .font(.system(size: 24, weight: .semibold))
                    })
                } //: HSTACK
                .padding(.horizontal, 20)
                
                List {
                    ForEach(searchResults, id: \.self) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name_display_first_last)
                                    .font(.system(.headline))
                                Text(item.team_full)
                                    .font(.system(.footnote))
                            } //: VSTACK
                            
                            Spacer()
                            
                            NavigationLink(destination: PlayerView(player: item)) {
                                
                            }
                        } //: HSTACK
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    } //: FOR
                } //: LIST
                .padding(.vertical, 0)
                .frame(maxWidth: 640)
                .listStyle(InsetGroupedListStyle())
            } //: VSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = .clear
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical, 10)
            .background(
                backgroundGradient.ignoresSafeArea()
            )
            .navigationBarTitle("Search Players", displayMode: .large)
            .navigationBarHidden(true)
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .preferredColorScheme(.light)
    }
}
