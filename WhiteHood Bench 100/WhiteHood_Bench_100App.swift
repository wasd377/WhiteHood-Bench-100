//
//  WhiteHood_Bench_100App.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

@main
struct WhiteHood_Bench_100App: App {
    
    @StateObject var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ContentViewViewModel())
                .environmentObject(IntroViewViewModel())
                .environmentObject(WorkoutViewViewModel())
                .environment(\.managedObjectContext, dataController.container.viewContext)
            
        }
    }
}
