//
//  HistoryView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 06.12.2023.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var vm: ContentViewViewModel
    
    
    var body: some View {
        
    
        
        VStack(alignment: .leading) {
            
            if vm.historyKOSTYL.isEmpty {
                Text("Здесь будет отображаться история всех прошедших тренировок с информацией о весе и количестве повторений.")
                    .padding(20)
            }
            
            
            ForEach(1...8, id: \.self) { weekNumber in
                
              

                if vm.historyKOSTYL.contains(weekNumber) {
                    Text("Неделя \(weekNumber)")
                        .font(.system(size: 20, weight: .bold))
                } else {
                    }
            
                ForEach(vm.history, id: \.self) { item in
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
        }
        .padding(20)
        .onAppear{
            vm.hitsoryKOSTYLCalculation()
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        HistoryView()
            .environmentObject(ContentViewViewModel())
          
    }
}
