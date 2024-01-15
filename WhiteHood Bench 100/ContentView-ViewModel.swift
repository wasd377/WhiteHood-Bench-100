//
//  ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var progress: [Progress]
    @Published var introduction: Introduction
    @Published var history: [Workout]
    @Published var historyKOSTYL: [Int]
  
    @Published var trainingActivated = false
    
    init() {
        progress = []
        introduction = Introduction(introCompleted: false, realBench: true)
        history = []
        historyKOSTYL = []
    }
    
    func hitsoryKOSTYLCalculation() {
        historyKOSTYL = []
        for workout in history {
            historyKOSTYL.append(Int(ceil(Double(workout.day)/7)))
        }
    }
    
 
    
    func Reset() {
        introduction = Introduction(introCompleted: false, realBench: true)
    }
}
