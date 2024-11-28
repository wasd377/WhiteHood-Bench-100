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
    
//    func countAverage(CDhistory: FetchedResults<CDWorkout>) {
//        if CDhistory.isEmpty {
//            return
//        } else {
//
//            vmProgress.formulaBrzycki = Double(CDhistory.last!.weight)*36/(37-Double(CDhistory.last!.reps))
//            vmProgress.formulaEpley = Double(CDhistory.last!.weight) * (1 + Double(CDhistory.last!.reps)/30)
//
//            vmProgress.formulaAverage = (vmProgress.formulaEpley + vmProgress.formulaBrzycki) / 2
//        }
//    }
    

    func deleteHistory() {
        do {
            try moc.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "CDWorkout")))
          try moc.save()
        } catch {
        }    }

    
    var body: some View {
     
        let modifiedDate = vm.addingDays > 0 ? Calendar.current.date(byAdding: .day, value: vm.addingDays, to: vm.today)! : Date()
        let currentDay = Calendar.current.dateComponents([.day], from: vm.startDay, to: modifiedDate)
        
        // Переводим Date Components в Int
        let dayNumber = currentDay.day! + 1
         
        let weekN = Int(ceil(Double(dayNumber)/7))
        let rightTrainingId = CDhistory.count > 0 ? (CDhistory.count + 2 > weekN * 2 ? weekN * 2 : CDhistory.count + 2) : 2 //leftTrainingId + 1 //Int(weekN*2)
        let leftTrainingId = rightTrainingId - 1 //CDhistory.count > 0 ? (Int(weekN*2-1) > CDhistory.last!.id ? ) : 1
        
        
        // Просчитываем номер текущей тренировки
        let trainingId =
        CDhistory.count > 0 ? (CDhistory.last!.id > leftTrainingId ? rightTrainingId : leftTrainingId) : 1
        
//        // Просчитываем активность кнопки Тренировки, по правилам программы должно быть не более 2х занятий в неделю, примерно равномерно удаленных друг от друга.
//        let trainingDisabled = CDhistory.count > 0 || CDhistory.count == weekN ?
//        (Int16(dayNumber) < (CDhistory.last!.day + 3) ? true : false)
//        : false
        
        
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
                        .foregroundColor(CDhistory.count >= leftTrainingId ? (CDhistory[leftTrainingId-1].isDone == true ? Color.green : Color.red) : Color.red)
                    Spacer()
                    Text("Тренировка №\(rightTrainingId)")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(CDhistory.count >= rightTrainingId ? (CDhistory[leftTrainingId-1].isDone == true ? Color.green : Color.red) : Color.red)
                }
                .padding(.bottom, 10)
                .padding([.leading, .trailing], 20)
                HStack{
                    Spacer()
                    LargeButton(title: "Потренироваться", disabled: vm.trainingDisabled, backgroundColor: .black) {
                        vm.trainingActivated = true
                    }
                    Spacer()
                }
              
                
                // Поясняем, почему кнопка заблокирована
                if vm.trainingDisabled {
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Программа закончена!"), message: Text("8 недель прошли, а это значит, что пора подводить итоги! В начале программы ваш жим лежа составлял \(UserDefaults.standard.double(forKey: "StartBench"),specifier: "%.2f") кг, а сейчас составляет уже \((vmProgress.formulaAverage),specifier: "%.2f"). Поздравляем!") , dismissButton: .default(Text("Начать сначала")) {
                UserDefaults.resetStandardUserDefaults()
                deleteHistory()
                vm.introduction.introCompleted = false
                vm.addingDays = 0
            })
               }
        .onAppear {
         //   countAverage(CDhistory: CDhistory)
            if dayNumber > 3 {
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
