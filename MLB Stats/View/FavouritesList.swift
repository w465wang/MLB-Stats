//
//  FavouritesList.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-09.
//

import SwiftUI
import CoreData

struct FavouritesList: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var items: FetchedResults<Item>
    
    // MARK: - INIT
    
    init(sortValue: String, filterValue: String) {
        var sortDescriptors = [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)]
        if sortValue == "name" {
            sortDescriptors = [NSSortDescriptor(keyPath: \Item.lastName, ascending: true)]
        } else if sortValue == "team" {
            sortDescriptors = [NSSortDescriptor(keyPath: \Item.team, ascending: true)]
        }
        
        if filterValue == "none" {
            _items = FetchRequest<Item>(
                sortDescriptors: sortDescriptors
            )
        } else {
            _items = FetchRequest<Item>(
                sortDescriptors: sortDescriptors,
                predicate: NSPredicate(format: "team == %@", filterValue)
            )
        }
    }
    
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
    }
}

// MARK: - PREVIEW

struct FavouritesList_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesList(sortValue: "recent", filterValue: "Los Angeles Angels")
    }
}
