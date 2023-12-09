//
//  WorkoutViewViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 09.12.2023.
//

import Foundation



class WorkoutViewViewModel: ObservableObject {
    
    @Published var workout: Workout
    
    init() {
        workout = Workout(id: 1, day: 1, isDone: false, weight: 0, reps: 0)
    }
    
}
