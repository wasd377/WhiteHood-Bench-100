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
    
    func newStart() {
        
        if Int(startingRepsString)! == 1 {
           calculatedBench = Double(startingBenchString)!
        } else {
            
            let brzykiFormula = Int(Double(startingBenchString)!)*36/(37-Int(Double(startingRepsString)!))
            let epleyFormula = Int(Double(startingBenchString)!*(1+Double(startingRepsString)!/30))
            calculatedBench = Double((brzykiFormula+epleyFormula)/2)
            
        }
        
        // Используется для расчета максимума в жиме на старте.
        let realStart = Int(startingRepsString)! == 1 ? true : false

        // Сохраняем стартовые данные на устройстве
        UserDefaults.standard.set(calculatedBench, forKey: "StartBench")
        UserDefaults.standard.set(realStart, forKey: "RealStart")
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "StartDate")
        UserDefaults.standard.set(Double(benchGoal), forKey: "BenchGoal")

        // Обнуляем поля ввода (понадобится при сбросе прогресса и новом старте)
        startingRepsString = ""
        startingBenchString = ""
        benchGoal = ""
        calculatedBench = 0.0
    }
    
    
}
