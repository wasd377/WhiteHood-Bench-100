//
//  CDWorkout+CoreDataProperties.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 24.01.2024.
//
//

import Foundation
import CoreData


extension CDWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDWorkout> {
        return NSFetchRequest<CDWorkout>(entityName: "CDWorkout")
    }

    @NSManaged public var id: Int16
    @NSManaged public var day: Int16
    @NSManaged public var isDone: Bool
    @NSManaged public var reps: Int16
    @NSManaged public var weight: Double

}

extension CDWorkout : Identifiable {

}
