//
//  WorkoutView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI
import Foundation
import CoreData

struct WorkoutView: View {
    
    @Environment(\.managedObjectContext) var moc
 
    static var getHistoryFetchRequest: NSFetchRequest<CDWorkout> {
            let request: NSFetchRequest<CDWorkout> = CDWorkout.fetchRequest()
            request.sortDescriptors = []
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>

    @EnvironmentObject var vmWorkout : WorkoutViewViewModel
    @EnvironmentObject var vm : ContentViewViewModel
    
    @State var enterWeight = ""
    @State var enterReps = ""
    
    var workout : Workout
     
    var body: some View {
          
            VStack {
                Text("Тренировка №\(CDhistory.count+1)")
                    .padding(.bottom, 20)
                HStack {
                    Text("Рабочий вес")
                        .font(.title3)
                    Spacer()
                    VStack(alignment: .trailing){
                        HStack {
                            Text("План")
                            Text("**\((vmWorkout.planWeight),specifier: "%.2f")** кг")
                           
                        }
                        HStack{
                            Text("Факт")
                            TextField("", text: $enterWeight)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 50)
                            Text("кг")
                        }
                    }
                }
                .padding(.bottom, 10)
                HStack{
                    Text("Количество повторений")
                        .font(.title3)
                    Spacer()
                    VStack(alignment: .trailing){
                        HStack{
                            Text("План")
                            Text("**\(vmWorkout.planReps)** раз")
                        
                        }
                        HStack{
                            Text("Факт")
                            TextField("", text: $enterReps)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 50)
                            Text("раз")
                        }
                    }
                }
                .padding(.bottom, 30)
                HStack {
                    Spacer()
                    Button("Отменить") {
                        vm.trainingActivated = false
                    }
                    Spacer()
                    LargeButton(title: "Сохранить", disabled: Int(enterReps) ?? 0 > 0 && Double(enterWeight) ?? 0 > 0 ? false :  true, backgroundColor: .black) {
                        let savingworkout = CDWorkout(context: moc)
                        savingworkout.id = Int16(CDhistory.count+1)
                        savingworkout.day = Int16(workout.day)
                        savingworkout.isDone = true
                        savingworkout.weight = Double(enterWeight)!
                        savingworkout.reps = Int16(enterReps)!
                        
                        try? moc.save()
                        
                        vm.trainingActivated = false
                    }
                    Spacer()
                }
            
            }
            .padding()
            .onAppear{
                vmWorkout.calculateWorkout(workoutDay: 25)
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
