//
//  IntroViewViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 20.02.2024.
//

import Foundation
import CoreData

class IntroViewViewModel: ObservableObject  {
    
    @Published var startingBenchString = ""
    @Published var startingRepsString = ""
    @Published var benchGoal = ""
    @Published var calculatedBench = 0.0
    
    @discardableResult
    func newStart() -> Bool {
        guard let startingBench = Double(startingBenchString),
              let startingReps = Int(startingRepsString),
              startingReps > 0,
              let goal = Double(benchGoal) else {
            return false
        }
        
        if startingReps == 1 {
           calculatedBench = startingBench
        } else {
            // Brzycki: защита от деления на ноль / отрицательного знаменателя при reps >= 37
            let brzyckiDenominator = max(37 - startingReps, 1)
            let brzyckiFormula = Int(startingBench) * 36 / brzyckiDenominator
            let epleyFormula = Int(startingBench * (1 + Double(startingReps) / 30))
            calculatedBench = Double((brzyckiFormula + epleyFormula) / 2)
        }
        
        // Используется для расчета максимума в жиме на старте.
        let realStart = startingReps == 1

        // Сохраняем стартовые данные на устройстве
        UserDefaults.standard.set(calculatedBench, forKey: ProgramDefaults.startBench)
        UserDefaults.standard.set(realStart, forKey: ProgramDefaults.realStart)
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: ProgramDefaults.startDate)
        UserDefaults.standard.set(goal, forKey: ProgramDefaults.benchGoal)
        UserDefaults.standard.removeObject(forKey: ProgramDefaults.newBench)

        // Обнуляем поля ввода (понадобится при сбросе прогресса и новом старте)
        startingRepsString = ""
        startingBenchString = ""
        benchGoal = ""
        calculatedBench = 0.0
        return true
    }
}
