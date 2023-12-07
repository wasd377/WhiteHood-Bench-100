//
//  WorkoutView-ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import Foundation

class WorkoutViewViewModel: ObservableObject {
    @Published var workout: Workout
    
    init() {
        workout = Workout(id: 1, week: 1, isDone: false, weight: 65, reps: 3)
    }
    

}
