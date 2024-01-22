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
  //  @Published var history: [Workout]
    @Published var historyKOSTYL: [Int]
    
    @Published var startDay = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "StartDate"))
    @Published var today = Date()
    //Эта переменная нужна только для дебага
    @Published var addingDays = 0
    @Published var trainingActivated = false
    
    init() {
        progress = []
        introduction = Introduction(introCompleted: false, realBench: true)
        historyKOSTYL = []
    }

    
    func Reset() {
        introduction = Introduction(introCompleted: false, realBench: true)
    }
}
