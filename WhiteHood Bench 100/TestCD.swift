//
//  TestCD.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 14.01.2024.
//

import SwiftUI
import CoreData

struct TestCD: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var CDhistory: FetchedResults<CDWorkout>
    @StateObject var dataController = DataController()
    
    var body: some View {
        VStack {
            List(CDhistory) { workout in
                HStack {
                    Text("id: \(workout.id)")
                    Text("Day: \(workout.day)")
                    Text("isDone: \(String(workout.isDone))")
                    Text("weight: \(workout.weight)")
                    Text("reps: \(workout.reps)")
                }
                
            }
            
            Button("Add") {
                let weights = [10, 20, 30, 55, 75]

                let workout = CDWorkout(context: moc)
                workout.id = Int16(CDhistory.count+1)
                workout.day = Int16(1)
                workout.isDone = true
                workout.weight = Double(weights.randomElement()!)
                workout.reps = Int16(1)
                
                try? moc.save()
            }
        }
    }
        
      
}
    

struct TestCD_Previews: PreviewProvider {
    
    static var previews: some View {
        TestCD()
           
    }
}
