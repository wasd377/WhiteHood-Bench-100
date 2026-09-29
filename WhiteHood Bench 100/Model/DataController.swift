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
                // Без рабочего store приложение всё равно откроется, но сохранение/история не работают.
                // Логируем явно, чтобы проще ловить проблемы на устройствах.
                assertionFailure("Core Data failed to load: \(error.localizedDescription)")
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /// Удаляет все тренировки и сразу мержит изменения в viewContext (иначе UI видит «призраков»).
    static func deleteAllWorkouts(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDWorkout.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                into: [context]
            )
        } catch {
            print("Failed to delete workout history: \(error.localizedDescription)")
        }
    }
}
