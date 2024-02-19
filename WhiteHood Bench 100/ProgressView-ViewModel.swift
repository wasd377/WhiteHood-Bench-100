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
    
}
