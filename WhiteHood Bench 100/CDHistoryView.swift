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
    
    @State var CDhistoryKOSTYL: [Int] = []
    
    static var getHistoryFetchRequest: NSFetchRequest<CDWorkout> {
            let request: NSFetchRequest<CDWorkout> = CDWorkout.fetchRequest()
            request.sortDescriptors = []
            return request
       }
    
    @FetchRequest(fetchRequest: getHistoryFetchRequest) var CDhistory: FetchedResults<CDWorkout>
    
    func CDhistoryKOSTYLCalculation() {
        CDhistoryKOSTYL = []
        for workout in CDhistory {
            CDhistoryKOSTYL.append(Int(ceil(Double(workout.day)/7)))
        }
    }
    
    func deleteHistory() {
        do {
            try moc.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "CDWorkout")))
          try moc.save()
        } catch {
        }    }

    

    
    
    var body: some View {
        
    
        
        VStack(alignment: .leading) {
            
            if CDhistoryKOSTYL.isEmpty {
                Text("Здесь будет отображаться история всех прошедших тренировок с информацией о весе и количестве повторений.")
                    .padding(20)
            } else {
                
                
                ForEach(1...8, id: \.self) { weekNumber in
                    if CDhistoryKOSTYL.contains(weekNumber) {
                        Text("Неделя \(weekNumber)")
                            .font(.system(size: 20, weight: .bold))
                    } else {
                    }
                    
                    ForEach(CDhistory, id: \.self) { item in
                        if Int(ceil(Double(item.day)/7)) == weekNumber {
                            HStack {
                                Spacer()
                                Text("Тренировка №\(item.id)")
                                Spacer()
                                VStack(alignment: .leading) {
                                    HStack{
                                        Text("Вес:")
                                        Text("\(item.weight, specifier: "%.2f")")
                                    }
                                    HStack {
                                        Text("Повторения:")
                                        Text("\(item.reps)")
                                        Text("раз")
                                    }
                                }
                                
                            }
                            .padding(.bottom, 10)
                            
                        }
                    }
                }
                Button("Сбросить всё") {
                    UserDefaults.resetStandardUserDefaults()
                    deleteHistory()
                    vm.introduction.introCompleted = false
                }
            }
            
            
        }
        .padding(20)
      
        .onAppear{
            CDhistoryKOSTYLCalculation()
        }
    }
}

struct CDHistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        CDHistoryView()
            .environmentObject(ContentViewViewModel())
          
    }
}
