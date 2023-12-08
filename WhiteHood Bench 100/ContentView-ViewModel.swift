//
//  ViewModel.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation

class ContentViewViewModel: ObservableObject {
    @Published var progress: Progress
    @Published var introduction: Introduction
    
    init() {
        progress = Progress(currentBench: 0, currentDay: 1)
        introduction = Introduction(introCompleted: false, realBench: true)
    }
}
