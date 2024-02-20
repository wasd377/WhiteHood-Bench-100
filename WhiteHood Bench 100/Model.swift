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

struct Introduction: Codable {
    var introCompleted: Bool
    var realBench: Bool
}



