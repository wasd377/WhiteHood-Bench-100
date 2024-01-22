//
//  ProgressView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI
import Charts
import CoreData


struct ProgressView: View {
    
    @EnvironmentObject var vm: ContentViewViewModel
    
    @Environment(\.managedObjectContext) var moc
    
    static var getHistoryFetchRequest: NSFetchRequest<CDWorkout> {
            let request: NSFetchRequest<CDWorkout> = CDWorkout.fetchRequest()
            request.sortDescriptors = []
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    
    let xMarkValues = stride(from: 0, to: 57, by: 7).map{ $0 }
    
    let startingData = [
        Progress(day: 1, weight: UserDefaults.standard.double(forKey: "StartBench"))]
    
    @State private var formulaAverage = 0
    
    @State var formulaBrzycki = 0.0
    @State var formulaEpley = 0.0
 
    @State var  limitColors : [Color] = [.red, .yellow]
    @State var colorCount : Double = 5.0
    @State var newvar = [1,2,3]
    
    func countAverage() {
        if CDhistory.isEmpty {
            return
        } else {
            
            formulaBrzycki = Double(CDhistory.last!.weight)*36/(37-Double(CDhistory.last!.reps))
            formulaEpley = Double(CDhistory.last!.weight) * (1 + Double(CDhistory.last!.reps)/30)
        }
    }
    
    func calculateColors() {

      if colorCount > 66.0 {
          limitColors = [.red, .green]
      } else {
          limitColors = [.red, .yellow]
      }


    }
           
           var body: some View {
               
               let yAxisSize = [
                0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130
               ]
               
               let goal = [100]
               
               let formulaAverage = Double((formulaBrzycki+formulaEpley)/2)
               
                  
                   VStack {
                       
                       Chart {
                           ForEach(CDhistory, id: \.self) { item in
                               LineMark(
                                x: .value("Time", item.day),
                                y: .value("EV", item.weight)
                               )
                               .foregroundStyle(
                            .linearGradient(
                                colors: limitColors,
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                               )
                               .symbol(.circle)
                               .symbolSize(100)
                           }
                           .foregroundStyle(by: .value("Type", "EV")) // Here
                           
                           ForEach(startingData, id: \.self) { item in
                               LineMark(
                                x: .value("Time", 0),
                                y: .value("EV", item.weight)
                               )
                               .foregroundStyle(.blue)
                               .symbol(.circle)
                               .symbolSize(100)
                               
                           }
                           .foregroundStyle(by: .value("Type", "AV")) // Here
                           
                           ForEach(goal, id: \.self) { item in
                               LineMark(
                                x: .value("Time", 56),
                                y: .value("EV", 100)
                               )
                               .foregroundStyle(.yellow)
                               .symbol {
                                               Image(systemName: "star.fill")
                                                   .foregroundColor(.yellow)
                                                   .font(.system(size: 17))   // default
                                           }
                               .symbolSize(100)
                           }
                           
                       }
                       .padding([.trailing, .leading], 20)
                       .chartLegend(.hidden) // optional
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
                       .onAppear {
                           calculateColors()
                       }
                       
                       HStack {
                           Text("Жим на старте: ")
                           Text("**\(UserDefaults.standard.double(forKey: "StartBench"),specifier: "%.2f")**")
                               .foregroundColor(.blue)
                           Text("кг")
                       }
                       HStack {
                           Text("Жим сейчас (в теории): ")
                           if CDhistory.isEmpty {
                               Text("**?**")
                                   .foregroundColor(.red)
                           } else {
                                   Text("**\(formulaAverage, specifier: "%.2f")**")
                                       .foregroundColor(formulaAverage < UserDefaults.standard.double(forKey: "StartBench") ? .red : .green)
                               }
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
                               
                               if CDhistory.isEmpty {
                                   
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
                      
                       .padding(.bottom)
                      Spacer()
                    

                        }
                   .onAppear {
                      countAverage()
                   }
                   }
    
                 
               
           
    
}

struct ProgressView_Previews: PreviewProvider {
    
    var startingData = 70.0
    
    static var previews: some View {
        ProgressView()
            .environmentObject(ContentViewViewModel())
    }
}
