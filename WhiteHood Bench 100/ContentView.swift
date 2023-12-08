//
//  ContentView.swift
//  WhiteHood Bench 100
//
//  Created by Natalia D on 01.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm: ContentViewViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                if vm.introduction.introCompleted == true {
                    MenuView()
                } else {
                    IntroView()
                    
                }
            }
        }
    }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentViewViewModel())
        
    }
}
