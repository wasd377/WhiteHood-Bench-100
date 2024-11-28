//
//  HistoryView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI
import CoreData

struct CDHistoryView: View {
    
    @EnvironmentObject var vm: ContentViewViewModel
    
    @Environment(\.managedObjectContext) var moc
    
    static var getHistoryFetchRequest: NSFetchRequest<CDWorkout> {
            let request: NSFetchRequest<CDWorkout> = CDWorkout.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \CDWorkout.id, ascending: true)
            ]
            return request
       }
    
    func CDhistoryKOSTYLCalculation() {
        for workout in CDhistory {
            if workout.isDone == true {
                vm.historyKOSTYL.append(Int(ceil(Double(workout.day)/7)))
            }
        }
    }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    


    

    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if CDhistory.isEmpty {
                Text("Здесь будет отображаться история всех прошедших тренировок с информацией о весе и количестве повторений.")
                    .padding(20)
            } else {
                
                List{
                    ForEach(1...8, id: \.self) { weekNumber in
                        if vm.historyKOSTYL.contains(weekNumber) {
                            Text("Неделя \(weekNumber)")
                                .font(.system(size: 20, weight: .bold))
                        } else {
                        }
                        
                        ForEach(CDhistory, id: \.self) { item in
                          
                                if Int(ceil(Double(item.day)/7)) == weekNumber {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Тренировка №\(item.id)")
                                            Text("День \(item.day)")
                                        }
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            HStack{
                                                Text("Вес:")
                                                Text("\(item.weight, specifier: "%.2f")")
                                                Text("кг")
                                            }
                                            HStack {
                                                Text("Повторения:")
                                                Text("\(item.reps)")
                                                //Text("раз")
                                            }
                                        }
                                        
                                    }
                                    .padding(.bottom, 10)
                                    
                                }
                            }
                        
                    }
                    
                }
                .listStyle(.plain)
                
            
            }
            
            Button("Начать сначала") {
                UserDefaults.standard.removeObject(forKey: "StartBench")
                UserDefaults.standard.removeObject(forKey: "RealStart")
                UserDefaults.standard.removeObject(forKey: "StartDate")
                UserDefaults.standard.removeObject(forKey: "BenchGoal")

                vm.introduction.introCompleted = false
                
            }
            
            
        }
        .padding(20)
      
        .onAppear{
            CDhistoryKOSTYLCalculation()
        }
    }
}

struct CDHistoryView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        CDHistoryView()
            .environmentObject(ContentViewViewModel())
            .environment(\.managedObjectContext, dataController.container.viewContext)
          
    }
}
