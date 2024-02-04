//
//  ProgressView-ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 04.02.2024.
//

import Foundation
import SwiftUI
import CoreData

class ProgressViewViewModel: ObservableObject {
    
    @Published var formulaBrzycki = 0.0
    @Published var formulaEpley = 0.0
    @Published var formulaAverage = 0.0
    @Published var realStart : Bool = UserDefaults.standard.bool(forKey: "RealStart") == true ? true : false
    
    func countAverage(CDhistory: FetchedResults<CDWorkout>) {
        if CDhistory.isEmpty {
            return
        } else {
            
            formulaBrzycki = Double(CDhistory.last!.weight)*36/(37-Double(CDhistory.last!.reps))
            formulaEpley = Double(CDhistory.last!.weight) * (1 + Double(CDhistory.last!.reps)/30)
            formulaAverage = Double((formulaBrzycki+formulaEpley)/2)
        }
    }
    
}
