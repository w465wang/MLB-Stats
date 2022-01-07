//
//  Persistence.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import CoreData

struct PersistenceController {
    // MARK: - PERSISTENCE CONTROLLER
    
    static let shared = PersistenceController()

    // MARK: - PERSISTENCE CONTAINER
    
    let container: NSPersistentContainer

    // MARK: - INITIALIZATION
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MLB_Stats")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - PREVIEW
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.name = "Mike Trout"
            newItem.position = "CF"
            newItem.team = "Los Angeles Angels"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
