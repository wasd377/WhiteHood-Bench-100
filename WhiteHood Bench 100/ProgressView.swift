//
//  ProgressView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI
import Charts


struct ProgressView: View {
    
    @EnvironmentObject var vm: ContentViewViewModel
    
    let xMarkValues = stride(from: 0, to: 57, by: 7).map{ $0 }
    
    let startingData = [
        Progress(day: 1, weight: UserDefaults.standard.double(forKey: "StartBench"))]
    
    @State private var formulaAverage = 0
    
    @State var formulaBrzycki = 0.0
    @State var formulaEpley = 0.0
 
    
  func countAverage() {
        if vm.history.isEmpty {
            return
        } else {
            
            formulaBrzycki = Double(vm.history.last!.weight)*36/(37-Double(vm.history.last!.reps))
            formulaEpley = Double(vm.history.last!.weight) * (1 + Double(vm.history.last!.reps)/30)
        }

    }
           
           var body: some View {
               
               let yAxisSize = [
                0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130
               ]
               
               var formulaAverage = Double((formulaBrzycki+formulaEpley)/2)
                  
                   VStack {
                       Chart {
                           ForEach(vm.history, id: \.self) { item in
                               LineMark(
                                x: .value("Time", item.day),
                                y: .value("EV", item.weight)
                               )
                               .foregroundStyle(
                                .linearGradient(
                                    colors: [.red, .green],
                                    startPoint: .bottom,
                                    endPoint: .top)
                               )
                               .symbol(.circle)
                               .symbolSize(100)
                           }
                           .foregroundStyle(by: .value("Type", "EV")) // Here
                           
                           ForEach(startingData, id: \.self) { item in
                               LineMark(
                                x: .value("Time", item.day),
                                y: .value("EV", item.weight)
                               )
                               .foregroundStyle(.blue)
                               .symbol(.circle)
                               .symbolSize(100)
                               
                           }
                           .foregroundStyle(by: .value("Type", "AV")) // Here
                           
                       }
                       .chartLegend(.hidden) // optional
                     //  .chartXScale(domain: 0...8*7)
                       .chartXAxis {
                           AxisMarks(preset: .aligned, values: xMarkValues) {
                               AxisGridLine()
                               let weekNumber = $0.as(Int.self)!
                               let weekNumberLabel = weekNumber/7
                               AxisValueLabel(centered: true) {
                               
                                       Text("\(weekNumberLabel+1)")
                                   
                                     
                               }
                                   
                           }

                       }
                       .chartYAxis {
                           AxisMarks(values: yAxisSize) {
                               AxisGridLine()
                               AxisTick()
                               let value = $0.as(Int.self)!
                               AxisValueLabel {
                                   Text("\(value) кг")
                               }
                               
                           }
                       }
                       
                       
                       .frame(height: 300)
                       .padding(.bottom)
                       
                       HStack {
                           Text("Максимальный жим на старте: ")
                           Text("**\(UserDefaults.standard.double(forKey: "StartBench"),specifier: "%.2f")**")
                               .foregroundColor(.blue)
                           Text("кг")
                       }
                       HStack {
                           Text("Максимальный сейчас (в теории): ")
                           Text("**\(UserDefaults.standard.double(forKey: "StartBench"),specifier: "%.2f")**")
                               .foregroundColor(.blue)
                           Text("кг")
                       }
                           .padding(.bottom)
                       Spacer()
                       Text("Текущий Теоретический Максимум (ТТМ)")
                       HStack {
                           
                           Image("BoydEpley")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 75)
                               .padding(.leading, 20)
                           Spacer()
                           
                           VStack {
                               
                               if vm.history.isEmpty {
                                   
                                   Text("**Бойду Эпли** и **Мэтту Бржыцки** нужны данные твоей первой тренировки для расчета текущего теоретического максимума.")
                                       .font(.system(size:15))
                               } else {
                                   
                                   Text("Формула **Эпли**")
                                   Text("\(formulaEpley, specifier: "%.2f")")
                                   
                                   
                                   Text("Формула **Бржыцки**")
                                   Text("\(formulaBrzycki, specifier: "%.2f")")
                                   
                                   Text("**Среднее**")
                                   Text("\(formulaAverage, specifier: "%.2f")")
                               }
                           }
                                
                              Spacer()
                                    Image("MattBrzycki")
                                     .resizable()
                                       .scaledToFit()
                                     .frame(width: 75)
                                     .padding(.trailing, 20)
                               
                             
                            
                       
                        }
                       VStack {
                       
                       }
                       .onAppear {
                          countAverage()
                       }
                      Spacer()

                        }  //.padding([.leading, .trailing], 10)
                   }
                 
               
           
    
}

struct ProgressView_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressView()
            .environmentObject(ContentViewViewModel())
    }
}
