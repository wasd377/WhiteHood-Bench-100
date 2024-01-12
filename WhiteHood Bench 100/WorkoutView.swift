//
//  WorkoutView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI
import Foundation

struct WorkoutView: View {
    
    @EnvironmentObject var vmWorkout : WorkoutViewViewModel
    @EnvironmentObject var vm : ContentViewViewModel
    
    @State var enterWeight = ""
    @State var enterReps = ""
    
    var workout : Workout
    
    var body: some View {
          
    
            VStack {
                Text("Тренировка №\(workout.id)")
                    .padding(.bottom, 20)
                Text("Рабочий вес")
                    .font(.title2)
                HStack {
                    Text("План")
                    Text("**\((vmWorkout.planWeight),specifier: "%.2f")** кг")
                    Spacer()
                    Text("Факт")
                    TextField("", text: $enterWeight)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                    Text("кг")
                }
                .padding(.bottom, 10)
                Text("Количество повторений")
                    .font(.title2)
                HStack{
                    Text("План")
                    Text("**\(vmWorkout.planReps)** раз")
                    Spacer()
                    
                    Text("Факт")
                    TextField("", text: $enterReps)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 50)
                    Text("раз")
                }
                .padding(.bottom, 30)
                HStack {
                    Button("Отменить") {
                        vm.trainingActivated = false
                    }
                    Spacer()
                    LargeButton(title: "Сохранить", disabled: Int(enterReps) ?? 0 > 0 && Double(enterWeight) ?? 0 > 0 ? false :  true, backgroundColor: .black) {
                        vm.history.append(Workout(id: vm.history.count+1, day: workout.day, isDone: true, weight: Double(enterWeight)!, reps: Int(enterReps)!))
                        vm.trainingActivated = false
                    }
                }
            
            }
            .padding()
            .onAppear{
                vmWorkout.calculateWorkout()
            }
        
      
    }
}

struct WorkoutView_Previews: PreviewProvider {
    
    static var workout = Workout(id: 1, day: 1, isDone: false, weight: 100, reps: 1)
    
    static var previews: some View {
        WorkoutView(workout: workout)
            .environmentObject(WorkoutViewViewModel())
            .environmentObject(ContentViewViewModel())
    }
}
