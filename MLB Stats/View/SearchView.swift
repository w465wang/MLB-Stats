//
//  SearchView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

struct SearchView: View {
    // MARK: - PROPERTIES
    
    @State var text: String = ""
    
    @State private var searchResults: [Player] = []
    
    // MARK: - FUNCTIONS
    
    private func searchTask() {
        Task {
            do {
                let results = try await getSearchResults(active: "Y", query: text)
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
                
                List {
                    
                }
                .listStyle(InsetGroupedListStyle())
                .padding(.vertical, 0)
                .frame(maxWidth: 640)
            } //: VSTACK
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .navigationBarTitle("Search Players", displayMode: .large)
            .padding()
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
