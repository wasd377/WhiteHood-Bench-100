//
//  MainView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel

    
    @State private var trainingActivated : String? = nil
    
    @State private var hintCourseShowing = false
    

    var startDay = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "StartDate"))
    
  
    
    var body: some View {
        
        var currentDay = Calendar.current.dateComponents([.day], from: startDay, to: Date())
        var date = currentDay.day!+1
        
        VStack(alignment: .leading) {
            //            VStack {
            //                Text("")
            //                Text("")
            //                HStack {
            //
            //                    Text(vm.progress.realBench == true ? "Стартовый максимум в жиме" : "Теоретический максимум в жиме")
            //                    Text("\(vm.progress.currentBench)")
            //                        .font(.system(size: 20, weight: .black))
            //                    Text("кг")
            //                }
            //                .frame(alignment: .trailing)
            //
            //
            //            }
            //            .frame(maxWidth: .infinity)
            //            .frame(height: 100)
            //            .background(Color.black)
            //            .foregroundColor(.white)
            
            Group {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Блок 1")
                        .font(.system(size: 36, weight: .bold))
                    
                    Text("Неделя 1")
                        .font(.system(size: 24, weight: .bold))
                    Text("")
                    //                    Image(systemName: "info.circle.fill")
                    //                        .onTapGesture {
                    //                            hintCourseShowing = true
                    //                        }
                    // .font(.system(size: 24))
                    //                        .foregroundColor(.blue)
                    
                    Text("День \(date)")
                        .font(.system(size: 16, weight: .bold))
                Spacer()
                    
                }
             //   .multilineTextAlignment(.leading)
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
            }
            .padding([.leading, .trailing], 20)
            
            HStack{
                Spacer()
                NavigationLink(destination: WorkoutView(workout: Workout(id: vm.history.count+1, day: currentDay.day!+1, isDone: false, weight: 0, reps: 0)), tag: "Workout", selection: $trainingActivated) { EmptyView() }
                
                LargeButton(title: "Потренироваться", backgroundColor: .black) {
                    trainingActivated = "Workout"
                }
                Spacer()
            }
            
            
            
            
            
            
            Spacer()
            
            
            Text("""
Тренировочный курс рассчитан на 2 блока по 4 недели в каждом.

На каждой неделе будет 2 тренировки с отдыхом 2-3 дня между ними.

На каждой тренировке у вас будет 3 подхода жима лежа.
""")
            .padding([.leading, .trailing], 20)
            
        }
    
}
        
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ContentViewViewModel())
    }
}
