//
//  IntroView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI
import CoreData

struct IntroView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel
    @EnvironmentObject var vmIntro : IntroViewViewModel
    @Environment(\.managedObjectContext) var moc
    
    func deleteHistory() {
        do {
            try moc.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "CDWorkout")))
          try moc.save()
        } catch {
        }    }

    var body: some View {
              
            VStack {
                Text("Какой максимальный вес в жиме лежа сейчас?")
                            .imageScale(.large)
                            .multilineTextAlignment(.center)
                
                HStack {
                    TextField("0", text: $vmIntro.startingBenchString)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                    Text("кг")
                        .multilineTextAlignment(.trailing)
                   
                }
                .frame(width: 100, alignment: .center)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                         
                
                    Text("На сколько повторений?")
                    
                        .imageScale(.large)
                      
                      .frame(width: 200, alignment: .leading)
                        .multilineTextAlignment(.leading)
                HStack {
                    TextField("0", text: $vmIntro.startingRepsString)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                    Text("раз")
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 100, alignment: .center)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                
                Text("Какая цель в жиме лежа?")
                            .imageScale(.large)
                            .multilineTextAlignment(.center)
                
                HStack {
                    TextField("0", text: $vmIntro.benchGoal)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(.roundedBorder)
                    Text("кг")
                        .multilineTextAlignment(.trailing)
                   
                }
                .frame(width: 100, alignment: .center)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                
                
                LargeButton(title: "Начать", disabled: vmIntro.startingRepsString.isEmpty || vmIntro.startingBenchString.isEmpty || vmIntro.benchGoal.isEmpty ? true :  false) {
                    
                    vm.introduction.introCompleted = true
                    vmIntro.newStart()
                }

                        }
            .onAppear{
                UserDefaults.resetStandardUserDefaults()
                deleteHistory()
                vm.addingDays = 0
                vm.trainingDisabled = false
            }
            }
        }
    


struct IntroView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        IntroView()
            .environmentObject(ContentViewViewModel())
            .environmentObject(IntroViewViewModel())
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
