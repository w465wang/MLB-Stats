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
    
    @AppStorage("searchSetting", store: .standard) var searchSetting = "Y"
    
    @State var text: String = ""
    @State private var searchResults: [Player] = []
    
    // MARK: - FUNCTIONS
    
    private func searchTask() {
        Task {
            do {
                let results = try await getSearchResults(active: searchSetting, query: text)
                searchResults = results
            } catch {
                print("Error", error)
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Search Players")
                        .font(.system(.largeTitle, design: .default))
                        .fontWeight(.heavy)
                        .padding(.leading, 4)
                } //: HSTACK
                .padding(.horizontal, 15)
                
                HStack {
                    TextField("e.g. Mike Trout", text: $text)
                        .font(.system(size: 24, weight: .bold))
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
                
                Picker(selection: $searchSetting, label: Text("Players")) {
                    Text("Active").tag("Y")
                    Text("Inactive/Historic").tag("N")
                    Text("All").tag("A")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: searchSetting) { new in
                    searchTask()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                
                List {
                    ForEach(searchResults, id: \.self) { item in
                        HStack {
                            NavigationLink(destination: PlayerView(player: item)) {
                                VStack(alignment: .leading) {
                                    Text(item.name_display_first_last)
                                        .font(.system(.headline))
                                    Text(item.team_full)
                                        .font(.system(.footnote))
                                } //: VSTACK
                            } //: NAV LINK
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
