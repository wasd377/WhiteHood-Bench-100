//
//  IntroView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct IntroView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel
    @Environment(\.managedObjectContext) var moc

    @State private var startingBenchString = ""
    @State private var startingRepsString = ""
    @State private var calculatedBench = 0.0
    
    var body: some View {
              
            VStack {

                    Spacer()
                        Text("Какой максимальный вес в жиме лежа сейчас?")
                            .imageScale(.large)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                
                HStack {
                    TextField("0", text: $startingBenchString)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                    Text("кг")
                        .multilineTextAlignment(.trailing)
                   
                }
                .frame(width: 100, alignment: .center)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                         
                
                    Text("На сколько повторений?")
                    .foregroundColor(.black)
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                      .frame(width: 200, alignment: .leading)
                        .multilineTextAlignment(.leading)
                HStack {
                    TextField("0", text: $startingRepsString)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                    Text("раз")
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 100, alignment: .center)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                
                LargeButton(title: "Начать", disabled: startingRepsString.isEmpty || startingBenchString.isEmpty ? true :  false, backgroundColor: .black) {
                    vm.introduction.introCompleted = true
                    
                    if Int(startingRepsString)! == 1 {
                       calculatedBench = Double(startingBenchString)!
                    } else {
                        
                        let brzykiFormula = Int(Double(startingBenchString)!)*36/(37-Int(Double(startingRepsString)!))
                        let epleyFormula = Int(Double(startingBenchString)!*(1+Double(startingRepsString)!/30))
                        calculatedBench = Double((brzykiFormula+epleyFormula)/2)
                        
                    }
                    
                    // Используется для расчета максимума в жиме на старте.
                    let realStart = Int(startingRepsString)! > 1 ? true : false

                    // Сохраняем стартовые данные на устройстве
                    UserDefaults.standard.set(calculatedBench, forKey: "StartBench")
                    UserDefaults.standard.set(realStart, forKey: "RealStart")
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "StartDate")
        
                    // Обнуляем поля ввода (понадобится при сбросе прогресса и новом старте)
                    startingRepsString = ""
                    startingBenchString = ""
                    
                    // Генерируем записи по будущим тренировкам. Без них приложение крашится на главном экране при попытке проверить тренировку, записи о которой нет в CD.
                    
//                    for i in 1...16 {
//                        
//                        let savingworkout = CDWorkout(context: moc)
//                        savingworkout.id = Int16(i)
//                        savingworkout.day = Int16(i)
//                        savingworkout.isDone = false
//                        savingworkout.weight = 0.0
//                        savingworkout.reps = 0
//                        
//                        try? moc.save()
//                    }
                    
                }
                
                Spacer()
                        }
            .padding(20)
                      
                    
                    
              
                
               
            }
     
            
         
        }
    


struct IntroView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        IntroView()
            .environmentObject(ContentViewViewModel())
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
