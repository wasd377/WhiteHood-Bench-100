//
//  DataController.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 13.01.2024.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "CDModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    

    
}
