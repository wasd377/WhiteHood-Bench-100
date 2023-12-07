//
//  Model.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation

struct Progress: Codable {
    var currentBench : Int
    var currentWeek : Int
    var introCompleted : Bool
    var realBench : Bool
}

struct Workout: Codable {
    var id: Int
    var week: Int
    var isDone: Bool
    var weight: Int
    var reps : Int
}



