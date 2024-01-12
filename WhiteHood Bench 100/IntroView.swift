//
//  IntroView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct IntroView: View {
    
    @EnvironmentObject var vm : ContentViewViewModel

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
                    
                    let realStart = Int(startingRepsString)! > 1 ? false: true
                    
                    UserDefaults.standard.set(calculatedBench, forKey: "StartBench")
                    UserDefaults.standard.set(realStart, forKey: "RealStart")
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "StartDate")

                    // read
               //     let date = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: key)
        
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
