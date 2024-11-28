//
//  WorkoutViewViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 09.12.2023.
//

import Foundation

class WorkoutViewViewModel: ObservableObject {
    
    @Published var planWeight = 0.0
    @Published var planReps = 0
    
    @Published var enterWeight = ""
    @Published var enterReps = ""
    
    var weeklyWeight = [
        1 : 0.82,
        2 : 0.85,
        3 : 0.88,
        4 : 0.92,
        5 : 0.95,
        6 : 0.98,
        7 : 1.02,
        8 : 1.05
    ]
    
   var weeklyReps = [
        1 : 5,
        2 : 5,
        3 : 5,
        4 : 5,
        5 : 3,
        6 : 3,
        7 : 2,
        8 : 2
    ]
    
    func calculateWorkout(workoutWeek: Int) {
    
        var actualBench : Double?
        
        if UserDefaults.standard.object(forKey: "NewBench") != nil {
            actualBench = UserDefaults.standard.double(forKey: "NewBench")
        } else {
           actualBench = UserDefaults.standard.double(forKey: "StartBench")
        }
        
        planWeight = weeklyWeight[workoutWeek]! * actualBench! //UserDefaults.standard.double(forKey: "StartBench")
        planReps = weeklyReps[workoutWeek]!
    }
    
    init() {
    
    }
    
}
