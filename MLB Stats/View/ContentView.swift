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

    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack {
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
                        } //: HSTACK
                    }
                    .onDelete(perform: deleteItems)
                } //: LIST
            } //: VSTACK
            .navigationBarTitle("Favourites", displayMode: .large)
            .onAppear() {
                UITableView.appearance().backgroundColor = .clear
            }
            .background(
                backgroundGradient.ignoresSafeArea()
            )
        } //: NAVIGATION
    }
    
    // MARK: - FUNCTIONS

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
