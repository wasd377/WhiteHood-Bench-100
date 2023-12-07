//
//  ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var progress: Progress
    
    init() {
        progress = Progress(currentBench: 0, currentWeek: 1, introCompleted: false, realBench: true)
    }
}
