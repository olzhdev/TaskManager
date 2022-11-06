//
//  ContentView.swift
//  TaskManager
//
//  Created by MAC on 06.11.2022.
//

import SwiftUI

struct ContentView: View {
 
    var body: some View {
        NavigationView {
            Home()
                .navigationTitle("Task Manager")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
