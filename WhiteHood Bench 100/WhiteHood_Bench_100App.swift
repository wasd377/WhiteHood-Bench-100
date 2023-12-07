//
//  WhiteHood_Bench_100App.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

@main
struct WhiteHood_Bench_100App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentViewViewModel())
        }
    }
}
