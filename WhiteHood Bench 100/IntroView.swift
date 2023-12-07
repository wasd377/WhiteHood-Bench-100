//
//  IntroView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct IntroView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel
    
    @State private var startingBench = 0
    @State private var startingReps = 0
    
    @State private var startingBenchString = ""
    @State private var startingRepsString = ""
    
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
                    Text("кг")
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 100, alignment: .center)
                    .keyboardType(.numberPad)
                    .padding(.bottom)
                
                LargeButton(title: "Начать", disabled: Int(startingRepsString) ?? 0 > 0 && Int(startingBenchString) ?? 0 > 0 ? false :  true, backgroundColor: .black) {
                    vm.progress.introCompleted = true
                    vm.progress.currentWeek = 1
                    vm.progress.realBench = Int(startingRepsString)! > 1 ? false: true
                    vm.progress.currentBench = Int(startingBenchString)!
                }
                
                Spacer()
                        }
            .padding(20)
                      
                    
                    
              
                
               
            }
     
            
         
        }
    


struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(ContentViewViewModel())
    }
}
