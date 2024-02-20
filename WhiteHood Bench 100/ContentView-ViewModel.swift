//
//  ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation
import CoreData
import SwiftUI

class ContentViewViewModel: ObservableObject {
    @Published var progress: [Progress]
    @Published var introduction: Introduction
    @Published var historyKOSTYL: [Int]
    
    @Published var startDay = UserDefaults.standard.object(forKey: "StartDate") as? Date  ?? Date() // Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "StartDate"))
    @Published var today = Date()
    
    @Published var trainingDisabled: Bool
    
    //Эта переменная нужна только для дебага
    @Published var addingDays = 0
    @Published var trainingActivated = false
    
    
    
    init() {
        progress = []
        introduction = Introduction(introCompleted: false, realBench: true)
        historyKOSTYL = []
        trainingDisabled = false
        
    }

    func Reset() {
        introduction = Introduction(introCompleted: false, realBench: true)
    }
    
    // Просчитываем активность кнопки Тренировки, по правилам программы должно быть не более 2х занятий в неделю, примерно равномерно удаленных друг от друга.
    func restCalculation(CDhistory: FetchedResults<CDWorkout>, weekN: Int, dayNumber: Int) {
        trainingDisabled = CDhistory.count > 0 || CDhistory.count == weekN ?
        (Int16(dayNumber) < (CDhistory.last!.day + 3) ? true : false)
        : false
    }
}
