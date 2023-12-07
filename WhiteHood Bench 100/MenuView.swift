//
//  MenuView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView{
            TabView {
                MainView()
                    .tabItem {
                        Label("Главная", systemImage: "house.fill")
                    }
                ProgressView()
                    .tabItem {
                        Label("Прогресс", systemImage: "chart.xyaxis.line")
                    }
                HistoryView()
                    .tabItem {
                        Label("История", systemImage: "list.dash")
                    }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(ContentViewViewModel())
    }
}
