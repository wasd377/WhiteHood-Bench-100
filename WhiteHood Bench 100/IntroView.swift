//
//  IntroView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct IntroView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel
    @EnvironmentObject var vmIntro : IntroViewViewModel
    @Environment(\.managedObjectContext) var moc

    var body: some View {
              
            VStack {
                Text("Какой максимальный вес в жиме лежа сейчас?")
                            .imageScale(.large)
                            .foregroundColor(.black)
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
                    .foregroundColor(.black)
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
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
                            .foregroundColor(.black)
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
                
                
                LargeButton(title: "Начать", disabled: vmIntro.startingRepsString.isEmpty || vmIntro.startingBenchString.isEmpty || vmIntro.benchGoal.isEmpty ? true :  false, backgroundColor: .black) {
                    
                    vm.introduction.introCompleted = true
                    vmIntro.newStart()
                }

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
