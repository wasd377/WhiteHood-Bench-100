//
//  WorkoutView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI

struct WorkoutView: View {
    
    @EnvironmentObject var vm : WorkoutViewViewModel
    
    @State var enterWeight = ""
    @State var enterReps = ""
    
    var workout : Workout
    
    var body: some View {
        
        
        
        NavigationView {
            VStack {
                Text("Week 1")
                Text("Workout #\(workout.id)")
                Text("Рабочий вес")
                Text("По плану")
                Text("По факту")
                TextField("", text: $enterWeight)
                Text("Количество повторений:")
                Text("По плану")
                Text("По факту")
                
                Button("Сохранить") {
                    //save func
                }
            
            }
            .padding()
        }
      
    }
}

struct WorkoutView_Previews: PreviewProvider {
    
    static var workout = Workout(id: 1, day: 1, isDone: false, weight: 65, reps: 3)
    
    static var previews: some View {
        WorkoutView(workout: workout)
            .environmentObject(WorkoutViewViewModel())
    }
}
