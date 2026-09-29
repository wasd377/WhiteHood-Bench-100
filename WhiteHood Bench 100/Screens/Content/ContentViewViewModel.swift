//
//  ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation
import CoreData
import SwiftUI

enum ProgramDefaults {
    static let startBench = "StartBench"
    static let realStart = "RealStart"
    static let startDate = "StartDate"
    static let benchGoal = "BenchGoal"
    static let newBench = "NewBench"
    
    static let allKeys = [startBench, realStart, startDate, benchGoal, newBench]
    
    static func clearAll() {
        for key in allKeys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    static func loadStartDate() -> Date {
        let interval = UserDefaults.standard.double(forKey: startDate)
        return interval > 0 ? Date(timeIntervalSince1970: interval) : Date()
    }
}

class ContentViewViewModel: ObservableObject {
    @Published var progress: [Progress]
    @Published var introduction: Introduction
    @Published var historyKOSTYL: [Int]
    
    @Published var startDay: Date
    @Published var today = Date()
    
    /// Есть ли активная программа (ключ StartBench). Нужен, чтобы SwiftUI переключил Intro ↔ Menu.
    @Published var hasActiveProgram: Bool
    
    @Published var trainingDisabled: Bool
    
    //Эта переменная нужна только для дебага
    @Published var addingDays = 0
    @Published var trainingActivated = false
    
    init() {
        progress = []
        introduction = Introduction(introCompleted: false, realBench: true)
        historyKOSTYL = []
        trainingDisabled = false
        startDay = ProgramDefaults.loadStartDate()
        hasActiveProgram = UserDefaults.standard.object(forKey: ProgramDefaults.startBench) != nil
    }

    func Reset() {
        introduction = Introduction(introCompleted: false, realBench: true)
        hasActiveProgram = false
        startDay = Date()
        trainingDisabled = false
        trainingActivated = false
        addingDays = 0
        historyKOSTYL = []
    }
    
    func applyProgramStart() {
        startDay = ProgramDefaults.loadStartDate()
        hasActiveProgram = true
        introduction.introCompleted = true
        trainingDisabled = false
        trainingActivated = false
        addingDays = 0
        historyKOSTYL = []
    }
    
    func clearProgram() {
        ProgramDefaults.clearAll()
        Reset()
    }
    
    // Просчитываем активность кнопки Тренировки, по правилам программы должно быть не более 2х занятий в неделю, примерно равномерно удаленных друг от друга.
    func restCalculation(CDhistory: FetchedResults<CDWorkout>, weekN: Int, dayNumber: Int) {
        guard let last = CDhistory.last else {
            trainingDisabled = false
            return
        }
        trainingDisabled = Int16(dayNumber) < (last.day + 3)
    }
    
    /// После только что сохранённой тренировки отдых нужен сразу, без ожидания обновления FetchResults.
    func markRestNeeded() {
        trainingDisabled = true
    }
}
