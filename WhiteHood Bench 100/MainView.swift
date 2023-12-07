//
//  MainView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel
    
    var formulaEpley = 1337
    var formulaBrzycki = 31337
    
    @State private var trainingActivated : String? = nil
    
    @State private var hintCourseShowing = false
    
    @State private var formulaAverage = 0
    
    var workout = Workout(id: 1, week: 1, isDone: false, weight: 65, reps: 3)
    
    func countAverage() {
        formulaAverage = (formulaEpley + formulaBrzycki) / 2
    }
    
    var body: some View {
        
        
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
                HStack {
                    Text("Неделя \(vm.progress.currentWeek)")
                        .font(.system(size: 36, weight: .bold))
                    Image(systemName: "info.circle.fill")
                        .onTapGesture {
                            hintCourseShowing = true
                        }
                       // .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
                Text("Тренировочный курс рассчитан на 4 блока по 4 недели в каждом. На каждой неделе будет 2 тренировки с отдыхом 2-3 дня между ними.")
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
                
                
                                NavigationLink(destination: WorkoutView(workout: workout), tag: "Workout", selection: $trainingActivated) { EmptyView() }
                
                                    LargeButton(title: "Потренироваться", backgroundColor: .black) {
                                        trainingActivated = "Workout"
                                        }
            
            
            
     
        
        
        Spacer()
        
//        Text("Теоретический максимум")
//        HStack {
//            VStack {
//                HStack {
//                    Image("BoydEpley")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50)
//                    VStack {
//                        Text("Бойд Эпли")
//                        Text("\(formulaEpley)")
//                    }
//                }
//                HStack {
//                    Image("MattBrzycki")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 50)
//                    VStack {
//                        Text("Мэтт Бржыцки")
//                        Text("\(formulaBrzycki)")
//                    }
//                }
//            }
//            VStack {
//                Text("Среднее")
//                Text("\(formulaAverage)")
//            }
//            .onAppear {
//                self.countAverage()
//            }
//        }
//      Spacer()
        
        }
      //  .padding(.leading, 20)
    
       // .ignoresSafeArea()
    
}
        
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ContentViewViewModel())
    }
}
