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
            request.sortDescriptors = []
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    
    var body: some View {
     
        let modifiedDate = Calendar.current.date(byAdding: .day, value: vm.addingDays, to: vm.today)!
        let currentDay = Calendar.current.dateComponents([.day], from: vm.startDay, to: modifiedDate)
        let weekNumber = ceil(Double(currentDay.day!/7))+1
        
        
        VStack(alignment: .leading) {
    
                HStack(alignment: .center) {
                    Spacer()
                    Text("День \(currentDay.day!+1)")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    Text("Неделя \(weekNumber, specifier: "%.0f")")
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
                    Text("Тренировка №\(Int(weekNumber*2-1))")
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 24, height: 24)
                        .foregroundColor(CDhistory[(Int(weekNumber*2-2))].isDone ? Color.green : Color.red)
                    Spacer()
                    Text("Тренировка №\(Int(weekNumber*2))")
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
                        vm.addingDays += 1
                    }
                    Spacer()
                }
                HStack {
                    Text( CDhistory[(Int(weekNumber*2-2))].isDone ? ("Yes it's done") : ("Not Done!"))
                }
            
                                   
                                   Spacer()
            }
                else {
                    WorkoutView()
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
     
    
}
        
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(WorkoutViewViewModel())
    }
}
