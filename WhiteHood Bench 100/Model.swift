//
//  Model.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import Foundation

struct Progress: Codable, Hashable {
    var day : Int
    var weight : Double

}

struct Workout: Codable, Hashable {
    var id: Int
    var day: Int
    var isDone: Bool
    var weight: Double
    var reps: Int
}

struct Introduction: Codable {
    var introCompleted: Bool
    var realBench: Bool

}




