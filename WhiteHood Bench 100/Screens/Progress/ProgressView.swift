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
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDWorkout.id, ascending: true)
            ]
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    
    let xMarkValues = stride(from: 0, to: 57, by: 7).map{ $0 }
    @State var yMarkValues = [0]
    let startingData = [
        Progress(day: 1, weight: UserDefaults.standard.double(forKey: ProgramDefaults.startBench))]
    let benchGoal = [Progress(day: 56, weight: UserDefaults.standard.double(forKey: ProgramDefaults.benchGoal))]
    
    @State var limitColors : [Color] = [.red, .yellow]
    @State var colorCount : Double = 5.0
    @State var newvar = [1,2,3]
    
    
    func countAverage(CDhistory: FetchedResults<CDWorkout>) {
        guard let last = CDhistory.last else {
            vmProgress.formulaBrzycki = 0
            vmProgress.formulaEpley = 0
            vmProgress.formulaAverage = 0
            return
        }
        
        let reps = max(Double(last.reps), 1)
        let brzyckiDenominator = max(37 - reps, 1)
        vmProgress.formulaBrzycki = Double(last.weight) * 36 / brzyckiDenominator
        vmProgress.formulaEpley = Double(last.weight) * (1 + reps / 30)
        vmProgress.formulaAverage = (vmProgress.formulaEpley + vmProgress.formulaBrzycki) / 2
        vmProgress.realStart = UserDefaults.standard.bool(forKey: ProgramDefaults.realStart)
    }
    
    func calculateColors() {
      if colorCount > 66.0 {
          limitColors = [.red, .green]
      } else {
          limitColors = [.red, .yellow]
      }
    }
    
    func calculateTableHeight() {
        yMarkValues = [0]
        let goal = UserDefaults.standard.double(forKey: ProgramDefaults.benchGoal)
        guard goal > 0 else { return }
        for number in 1...11 {
            yMarkValues.append(Int(goal)/10*number)
        }
    }
           
           var body: some View {
               
               let formulaAverage = vmProgress.formulaAverage
            
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
                                x: .value("Time", item.day),
                                y: .value("EV", item.weight)
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
                           AxisMarks(preset: .aligned, values: xMarkValues) { value in
                               AxisGridLine()
                               if let weekNumber = value.as(Int.self) {
                                   let weekNumberLabel = weekNumber/7
                                   AxisValueLabel(centered: true) {
                                       Text("\(weekNumberLabel+1)")
                                   }
                               }
                           }

                       }
                       .chartYAxis {
                           AxisMarks(values: yMarkValues) { value in
                               AxisGridLine()
                               AxisTick()
                               if let intValue = value.as(Int.self) {
                                   AxisValueLabel {
                                       Text("\(intValue) кг")
                                   }
                               }
                           }
                       }
                       
                       
                       .frame(height: 300)
                       .padding(.bottom)
                       .onAppear {
                           calculateColors()
                           calculateTableHeight()
                       }
                       
                       HStack {
                           vmProgress.realStart ? Text("Жим на старте: ") : Text("Жим на старте (в теории): ")
                           Text("**\(UserDefaults.standard.double(forKey: ProgramDefaults.startBench),specifier: "%.2f")**")
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
                                   .foregroundColor(formulaAverage < UserDefaults.standard.double(forKey: ProgramDefaults.startBench) ? .red : .green)
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
                      countAverage(CDhistory: CDhistory)
                   }
                   }
    
                 
               
           
    
}

struct ProgressView_Previews: PreviewProvider {
    
    var benchGoal = 1337.0
    var startingData = 70.0
    
    static var dataController = DataController()
    
    static var previews: some View {
        ProgressView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(ProgressViewViewModel())
        
        .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
