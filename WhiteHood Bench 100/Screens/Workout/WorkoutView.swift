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

    
    var trainingId : Int
    var dayNumber : Int
    var weekNumber : Int
  
    var body: some View {
          
            VStack {
                Text("Тренировка №\(trainingId)")
                    .font(.title3)
                    .padding(.bottom, 20)
                HStack {
                    Text("Рабочий вес")
                    Spacer()
                    VStack(alignment: .center){
                        
                        Text("План")
                        Text("**\((vmWorkout.planWeight),specifier: "%.2f")** кг")
                            .frame(height: 30)
                    
                    }
                    
                    Spacer()
                    VStack{
                   
                            Text("Факт")
                        HStack{
                            TextField("", text: $vmWorkout.enterWeight)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 50)
                            Text("кг")
                        }
                           
                        
                    }
                   
                }
                .padding(.bottom, 30)
                HStack{
                    Text("Количество \nповторений")
                       
                    Spacer()
                    VStack(alignment: .center){
                        
                        Text("План")
                            Text("**\(vmWorkout.planReps)**  раз")
                            .frame(height: 30)
                        
                        }
                    Spacer()
                    VStack{
                   
                            Text("Факт")
                        HStack{
                            TextField("", text: $vmWorkout.enterReps)
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
                    LargeButton(title: "Сохранить", disabled: Int(vmWorkout.enterReps) ?? 0 > 0 && Double(vmWorkout.enterWeight) ?? 0 > 0 ? false :  true, backgroundColor: .black) {
                        let savingworkout = CDWorkout(context: moc)
                        savingworkout.id = Int16(trainingId)
                        savingworkout.day = Int16(dayNumber)
                        savingworkout.isDone = true
                        savingworkout.weight = Double(vmWorkout.enterWeight)!
                        savingworkout.reps = Int16(vmWorkout.enterReps)!
                        
                        
                        DispatchQueue.main.async {
                            try? moc.save()
                            vm.restCalculation(CDhistory: CDhistory, weekN: weekNumber, dayNumber: dayNumber)
                        }
                        
                        if trainingId == 4 && Int(vmWorkout.enterReps) ?? 0 > Int(vmWorkout.planReps) {
                            UserDefaults.standard.set(Double(vmWorkout.enterWeight), forKey: "NewBench")
                        }
                        
                        vmWorkout.enterReps = ""
                        vmWorkout.enterWeight = ""
                        vm.trainingActivated = false
                        
                    }
                    Spacer()
                }
                
                if trainingId == 4 {
                    Text("Если плановый вес сегодня идет легко, то вместо планового количества повторений можно сделать подход на максимум. Тогда приложение пересчитает нагрузку на второй блок программы.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding([.trailing, .leading], 20)
                }
            
            }
            .padding()
            .onAppear{
                vmWorkout.calculateWorkout(workoutWeek: Int(weekNumber))
            }
        
      
    }
}

struct WorkoutView_Previews: PreviewProvider {
    
    static var dayNumber = 1
    static var trainingId = 4
    static var weekNumber = 1
    
    static var previews: some View {
        WorkoutView(trainingId: trainingId, dayNumber: dayNumber, weekNumber: weekNumber)
            .environmentObject(WorkoutViewViewModel())
            .environmentObject(ContentViewViewModel())

    }
}
