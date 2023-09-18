//
//  Persistence.swift
//  iNotes
//
//  Created by Aayam Adhikari on 14/09/2023.
//

import CoreData

struct PersistenceController {
    //MARK: - 1. PERSISTENT CONTROLLER.
    // Sets up the model, content, and store co-ordinator all at once
    static let shared = PersistenceController()

    //MARK: - 2. PERSISTENT CONTAINER
    // STORAGE PROPERTY FOR CORE DATA. PREFERRED WAY TO INITIALIZE OUR CORE DATA STACK,
    // AND LOAD OUR CORE DATA MODEL
    let container: NSPersistentContainer

    //MARK: - 3. INITIALIZE THE CORE DATA STACK (then load the peristent store)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "iNotes") // refering the data model
        
        // path to the temporary storage (we can access the non-disk storage, and is
        // great for unit testing and for using in the SwiftUI preview)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // load the store (persistent or temporary)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: - 4. PREVIEW (test configuration for the SwiftUI previews)
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true) // switch from default disk based data store to inMemory store
        let viewContext = result.container.viewContext
        
        // set up sample data to show in the preview (i.e in simulator)
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
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
