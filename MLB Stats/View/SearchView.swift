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
    
    // MARK: - FUNCTIONS
    
    private func searchTask() {
        Task {
            do {
                let results = try await getSearchResults(query: text)
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
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
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
            .navigationBarTitle("Search Players", displayMode: .large)
            .padding(.vertical, 10)
            .background(
                backgroundGradient.ignoresSafeArea()
            )
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
