//
//  MainView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI
import CoreData

struct MainView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel

    @State private var hintCourseShowing = false
    
    static var getHistoryFetchRequest: NSFetchRequest<CDWorkout> {
            let request: NSFetchRequest<CDWorkout> = CDWorkout.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDWorkout.id, ascending: true)
            ]
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    
    func fillHistoryGaps(weekN: Int) {
        if CDhistory.count < (weekN-1)*2 {
            
        }
    }
    
    var body: some View {
     
        let modifiedDate = Calendar.current.date(byAdding: .day, value: vm.addingDays, to: vm.today)!
        let currentDay = Calendar.current.dateComponents([.day], from: vm.startDay, to: modifiedDate)
        
        // Переводим Date Components в Int
        let dayNumber = currentDay.day! + 1
         
        let weekN = Int(ceil(Double(dayNumber)/7))
        let leftTrainingId = Int(weekN*2-1)
        let rightTrainingId = Int(weekN*2)
        let numberOfWorkouts = CDhistory.count
        
        // Просчитываем номер текущей тренировки
        let trainingId =
        numberOfWorkouts > 0 ? (CDhistory.last!.id > leftTrainingId ? rightTrainingId : leftTrainingId) : 1
        
        // Просчитываем активность кнопки Тренировки, по правилам программы должно быть не более 2х занятий в неделю, примерно равномерно удаленных друг от друга.
        let trainingDisabled = numberOfWorkouts > 0 || numberOfWorkouts == weekN ?
        (Int16(dayNumber) < (CDhistory.last!.day + 3) ? true : false)
        : false
        
        
        VStack(alignment: .leading) {
    
                HStack(alignment: .center) {
                    Spacer()
                    Text("День \(dayNumber)")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text("Неделя \(weekN)")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Group
                    { currentDay.day! < 29 ? Text("Блок 1") : Text("Блок 2")
                        
                    }
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                
            if vm.trainingActivated == false {
                HStack {
                    Text("Тренировка №\(leftTrainingId)")
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(numberOfWorkouts >= leftTrainingId ? (CDhistory[leftTrainingId-1].isDone == true ? Color.green : Color.red) : Color.red)
                    Spacer()
                    Text("Тренировка №\(rightTrainingId)")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(numberOfWorkouts >= rightTrainingId ? (CDhistory[leftTrainingId-1].isDone == true ? Color.green : Color.red) : Color.red)
                }
                .padding(.bottom, 10)
                .padding([.leading, .trailing], 20)
                HStack{
                    Spacer()
                    LargeButton(title: "Потренироваться", disabled: trainingDisabled, backgroundColor: .black) {
                        vm.trainingActivated = true
                    }
                    Spacer()
                }
                
                // Поясняем, почему кнопка заблокирована
                if trainingDisabled {
                    Text("Между тренировками должно пройти не менее 2-х дней отдыха, чтобы организм восстановился.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding([.trailing, .leading], 20)
                }
                    
                else {}
                
                // Только для тестирования
                HStack{
                    Spacer()
                    LargeButton(title: "Прибавить день", backgroundColor: .black) {
                        vm.addingDays += 1
                    }
                    Spacer()
                }
            
                                   
                                   Spacer()
            }
                else {
                    WorkoutView(trainingId: trainingId, dayNumber: dayNumber, weekNumber: weekN)
                }
            
            Spacer()
            
            
            Text("""
Тренировочный курс рассчитан на 2 блока по 4 недели в каждом.

На каждой неделе будет 2 тренировки с отдыхом 2-3 дня между ними.

На каждой тренировке у вас будет 3 подхода жима лежа.
""")
            .padding([.leading, .trailing, .bottom], 20)
            Spacer()
        }
        .onAppear {
            fillHistoryGaps(weekN: weekN)
            
        }
        
     
    
}
        
    
}

struct MainView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        MainView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(WorkoutViewViewModel())
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
