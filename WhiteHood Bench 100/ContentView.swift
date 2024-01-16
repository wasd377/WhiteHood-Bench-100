//
//  ContentView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var dataController = DataController()
    
    @EnvironmentObject var vm: ContentViewViewModel
    @EnvironmentObject var vmWorkout: WorkoutViewViewModel
    
    
    var body: some View {
        
        NavigationView {
            VStack {
               if vm.introduction.introCompleted == true {
                
              //  if UserDefaults.standard.object(forKey: "StartBench") != nil {
             MenuView()
                  
                } else {
                    IntroView()
                    
                }
            }
        }
    }
    }



struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(WorkoutViewViewModel())
          
        
    }
}
