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
    @EnvironmentObject var vmProgress: ProgressViewViewModel
    
    @Environment(\.managedObjectContext) var moc

    @State private var hintCourseShowing = false
    @State private var showingAlert = false
    
    static var getHistoryFetchRequest: NSFetchRequest<CDWorkout> {
            let request: NSFetchRequest<CDWorkout> = CDWorkout.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDWorkout.id, ascending: true)
            ]
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    
    var body: some View {
     
        let modifiedDate = vm.addingDays > 0
            ? (Calendar.current.date(byAdding: .day, value: vm.addingDays, to: vm.today) ?? Date())
            : Date()
        let currentDay = Calendar.current.dateComponents([.day], from: vm.startDay, to: modifiedDate)
        
        // Переводим Date Components в Int
        let dayNumber = (currentDay.day ?? 0) + 1
         
        let weekN = max(1, Int(ceil(Double(dayNumber)/7)))
        let rightTrainingId = CDhistory.count > 0 ? (CDhistory.count + 2 > weekN * 2 ? weekN * 2 : CDhistory.count + 2) : 2
        let leftTrainingId = rightTrainingId - 1
        
        
        // Просчитываем номер текущей тренировки
        let lastWorkoutId = CDhistory.last.map { Int($0.id) } ?? 0
        let trainingId =
        CDhistory.count > 0 ? (lastWorkoutId > leftTrainingId ? rightTrainingId : leftTrainingId) : 1
        
        let programFinished = dayNumber > 56
        
        
        VStack(alignment: .leading) {
    
                HStack(alignment: .center) {
                    Spacer()
                    Text("День \(dayNumber)")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text("Неделя \(min(weekN, 8))")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                    Group
                    { dayNumber < 29 ? Text("Блок 1") : Text("Блок 2")
                    }
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                
            if vm.trainingActivated == false {
                HStack {
                    Text("Тренировка №\(leftTrainingId)")
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(CDhistory.count >= leftTrainingId && leftTrainingId > 0 ? (CDhistory[leftTrainingId-1].isDone == true ? Color.green : Color.red) : Color.red)
                    Spacer()
                    Text("Тренировка №\(rightTrainingId)")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(CDhistory.count >= rightTrainingId && rightTrainingId > 0 ? (CDhistory[rightTrainingId-1].isDone == true ? Color.green : Color.red) : Color.red)
                }
                .padding(.bottom, 10)
                .padding([.leading, .trailing], 20)
                HStack{
                    Spacer()
                    LargeButton(title: "Потренироваться", disabled: vm.trainingDisabled || programFinished, backgroundColor: .black) {
                        vm.trainingActivated = true
                    }
                    Spacer()
                }
              
                
                // Поясняем, почему кнопка заблокирована
                if programFinished {
                    Text("Программа на 8 недель завершена. Можно начать сначала.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding([.trailing, .leading], 20)
                } else if vm.trainingDisabled {
                    Text("Между тренировками должно пройти не менее 2-х дней отдыха, чтобы организм восстановился.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding([.trailing, .leading], 20)
                }
            
                // Только для тестирования
//                HStack{
//                    Spacer()
//                    LargeButton(title: "Прибавить день", backgroundColor: .black) {
//                        vm.addingDays += 1
//                    }
//                    Spacer()
//                }
            
                                   
                                   Spacer()
            }
             
                else {
                    WorkoutView(trainingId: trainingId, dayNumber: dayNumber, weekNumber: min(weekN, 8))
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Программа закончена!"), message: Text("8 недель прошли, а это значит, что пора подводить итоги! В начале программы ваш жим лежа составлял \(UserDefaults.standard.double(forKey: ProgramDefaults.startBench),specifier: "%.2f") кг, а сейчас составляет уже \((vmProgress.formulaAverage),specifier: "%.2f"). Поздравляем!") , dismissButton: .default(Text("Начать сначала")) {
                DataController.deleteAllWorkouts(in: moc)
                vm.clearProgram()
            })
               }
        .onAppear {
            vm.restCalculation(CDhistory: CDhistory, weekN: weekN, dayNumber: dayNumber)
            if programFinished {
                showingAlert = true
            }
        }
        
     
    
}
    
        
    
}

struct MainView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        MainView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(WorkoutViewViewModel())
            .environmentObject(ProgressViewViewModel())
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
