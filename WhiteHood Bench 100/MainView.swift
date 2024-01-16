//
//  MainView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel

    @State private var hintCourseShowing = false

    var startDay = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "StartDate"))
    
    let today = Date()
   @State var addingDays = 0

    var body: some View {
     
        let modifiedDate = Calendar.current.date(byAdding: .day, value: addingDays, to: today)!
        let currentDay = Calendar.current.dateComponents([.day], from: startDay, to: modifiedDate)
        let weekNumber = ceil(Double(currentDay.day!/7))
        
        VStack(alignment: .leading) {
    
                HStack(alignment: .center) {
                    Spacer()
                    Text("День \(currentDay.day!+1)")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text("Неделя \(weekNumber+1, specifier: "%.0f")")
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
                    Text("Тренировка №1")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.red)
                    Spacer()
                    Text("Тренировка №2")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.red)
                }
                .padding(.bottom, 10)
                .padding([.leading, .trailing], 20)
                HStack{
                    Spacer()
                    LargeButton(title: "Потренироваться", backgroundColor: .black) {
                        vm.trainingActivated = true
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                    LargeButton(title: "Прибавить день", backgroundColor: .black) {
                        addingDays += 1
                    }
                    Spacer()
                }
                HStack{
                    Spacer()
                  //  Text(UserDefaults.standard.object(forKey: "StartBench") == nil ? "true" : "false")
                    Text("\(vm.introduction.introCompleted)" as String)
                        Button("Сбросить всё") {
                            vm.introduction.introCompleted = false
                            //UserDefaults.standard.removeObject(forKey: "StartBench")

                        }
                    }
                                   
                                   Spacer()
            }
                else {
                    WorkoutView(workout:Workout(id: vm.history.count+1, day: currentDay.day!+1, isDone: false, weight: 0, reps: 0))
                }
              //
            
            
            
            
            
            Spacer()
            
            
            Text("""
Тренировочный курс рассчитан на 2 блока по 4 недели в каждом.

На каждой неделе будет 2 тренировки с отдыхом 2-3 дня между ними.

На каждой тренировке у вас будет 3 подхода жима лежа.
""")
            .padding([.leading, .trailing, .bottom], 20)
            Spacer()
        }
    
}
        
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(WorkoutViewViewModel())
    }
}
