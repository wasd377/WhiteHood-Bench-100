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
    
    init() {
        progress = []
        introduction = Introduction(introCompleted: false, realBench: true)
        history = []
       
        
    }
}
