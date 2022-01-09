//
//  ContentView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @AppStorage("sortSetting", store: .standard) var sortSetting = "recent"
    @AppStorage("filterSetting", store: .standard) var filterSetting = "none"
    
    // MARK: - FUNCTIONS

    private func deleteItem(item: NSManagedObject) {
        viewContext.delete(item)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error \(nsError), \(nsError.userInfo)")
        }
    }

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
                        Picker(selection: $sortSetting, label: Text("Sort By")) {
                            Text("Recently Added").tag("recent")
                            Text("Name").tag("name")
                            Text("Position").tag("position")
                        }
                        .onChange(of: sortSetting) { new in
                            
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                    }
                    
                    Menu {
                        Text("Filter By")
                        Picker(selection: $filterSetting, label: Text("Filter By")) {
                            Text("None").tag("none")
                            Text("Team").tag("team")
                            Text("Position").tag("position")
                        }
                        .onChange(of: filterSetting) { new in
                            
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.primary)
                            .font(.system(size: 24))
                    }
                } //: HSTACK
                .padding(.horizontal, 15)
                
                Spacer()
                
                List {
                    ForEach(items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name!)
                                    .font(.system(.headline))
                                Text(item.team!)
                                    .font(.system(.footnote))
                            } //: VSTACK
                            
                            Spacer()
                            
                            Button(action: {
                                deleteItem(item: item)
                            }, label: {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 20))
                            })
                        } //: HSTACK
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    } //: FOR
                } //: LIST
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
