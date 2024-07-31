//
//  MenuView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject var vmWorkout : WorkoutViewViewModel
    @EnvironmentObject var vm : ContentViewViewModel
    
    
    var body: some View {
   
            TabView {
                MainView()
                    .tabItem {
                        Label("Главная", systemImage: "house.fill")
                    }
                ProgressView()
                    .tabItem {
                        Label("Прогресс", systemImage: "chart.xyaxis.line")
                    }
                CDHistoryView()
                    .tabItem {
                        Label("История", systemImage: "list.dash")
                    }
            }
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(WorkoutViewViewModel())
            .environmentObject(ProgressViewViewModel())
    }
}
