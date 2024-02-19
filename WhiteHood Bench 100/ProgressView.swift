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
    @EnvironmentObject var vmProgress: ProgressViewViewModel
    
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
    
    @State var limitColors : [Color] = [.red, .yellow]
    @State var colorCount : Double = 5.0
    @State var newvar = [1,2,3]
    
    func countAverage(CDhistory: FetchedResults<CDWorkout>) {
        if CDhistory.isEmpty {
            return
        } else {
            
            vmProgress.formulaBrzycki = Double(CDhistory.last!.weight)*36/(37-Double(CDhistory.last!.reps))
            vmProgress.formulaEpley = Double(CDhistory.last!.weight) * (1 + Double(CDhistory.last!.reps)/30)
            
            vmProgress.formulaAverage = (vmProgress.formulaEpley + vmProgress.formulaBrzycki) / 2
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
               
               let benchGoal = [UserDefaults.standard.double(forKey: "BenchGoal")]
               
          //     let formulaAverage = Double((formulaBrzycki+formulaEpley)/2)
               
                  
                   VStack {
                       
                       Chart {
                           ForEach(CDhistory, id: \.self) { item in
                               
                               if item.isDone == true {
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
                           
                           ForEach(benchGoal, id: \.self) { item in
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
                           UserDefaults.standard.bool(forKey: "realStart") == true ? Text("Жим на старте: ") : Text("Жим на старте (в теории): ")
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
                               Text("**\(vmProgress.formulaAverage, specifier: "%.2f")**")
                                   .foregroundColor(vmProgress.formulaAverage < UserDefaults.standard.double(forKey: "StartBench") ? .red : .green)
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
                                   Text("\(vmProgress.formulaEpley, specifier: "%.2f")")
                                   
                                   
                                   Text("Формула **Бржыцки**")
                                   Text("\(vmProgress.formulaBrzycki, specifier: "%.2f")")
                                   
                                   Text("**Среднее**")
                                   Text("\(vmProgress.formulaAverage, specifier: "%.2f")")
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
                      countAverage(CDhistory: CDhistory)
                   }
                   }
    
                 
               
           
    
}

struct ProgressView_Previews: PreviewProvider {
    
    var benchGoal = 1337.0
    var startingData = 70.0
    
    static var previews: some View {
        ProgressView()
            .environmentObject(ContentViewViewModel())
    }
}
