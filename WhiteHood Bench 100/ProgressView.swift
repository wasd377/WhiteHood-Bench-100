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
        Progress(currentBench: 70, currentDay: 1)
    ]
    
    var formulaEpley = 1337
    var formulaBrzycki = 31337
    
    @State private var formulaAverage = 0
    
    func countAverage() {
        formulaAverage = (formulaEpley + formulaBrzycki) / 2
    }
    
    
    let progressData = [
    Progress(currentBench: 56, currentDay: 2),
    Progress(currentBench: 58, currentDay: 5),
    Progress(currentBench: 62, currentDay: 8),
    Progress(currentBench: 65, currentDay: 11),
    Progress(currentBench: 71, currentDay: 14),
    Progress(currentBench: 75, currentDay: 18),
    Progress(currentBench: 79, currentDay: 21),
    Progress(currentBench: 83, currentDay: 25),
    Progress(currentBench: 87, currentDay: 30),
    Progress(currentBench: 90, currentDay: 34),
    Progress(currentBench: 93, currentDay: 41),
    Progress(currentBench: 105, currentDay: 47),
    Progress(currentBench: 125, currentDay: 56)
    ]
           
           var body: some View {
               
               let yAxisSize = [
                0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130
               ]
                  
                   VStack {
                       Chart {
                           ForEach(progressData, id: \.self) { item in
                               LineMark(
                                x: .value("Time", item.currentDay),
                                y: .value("EV", item.currentBench)
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
                                x: .value("Time", item.currentDay),
                                y: .value("EV", item.currentBench)
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
                       
                       Text("Теоретический максимум")
                        HStack {
                            VStack {
                                HStack {
                                    Image("BoydEpley")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50)
                                    VStack {
                                        Text("Бойд Эпли")
                                        Text("\(formulaEpley)")
                                    }
                                }
                                HStack {
                                    Image("MattBrzycki")
                                     .resizable()
                                       .scaledToFit()
                                       .frame(width: 50)
                                 VStack {
                                  Text("Мэтт Бржыцки")
                                       Text("\(formulaBrzycki)")
                                 }
                             }
                            }
                            VStack {
                                Text("Среднее")
                                Text("\(formulaAverage)")
                            }
                            .onAppear {
                                self.countAverage()
                            }
                        }
                      Spacer()

                        }  .padding([.leading, .trailing], 10)
                   }
                 
               
           
    
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
            .environmentObject(ContentViewViewModel())
    }
}
