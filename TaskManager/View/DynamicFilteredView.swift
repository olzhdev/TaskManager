//
//  DynamicFilteredView.swift
//  TaskManager
//
//  Created by MAC on 06.11.2022.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    ///CoreData request
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    ///Building Custom ForEach which will give Coredata objcet to build View
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content){
        ///Predicate to Filter current date Tasks
        let calendar = Calendar.current
        var predicate: NSPredicate!
        
        if currentTab == "Today" {
            
            let today = calendar.startOfDay(for: Date())
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            ///Filter Key
            let filterKey = "deadline"
            
            ///This will fetch task between today and tomorrow which is 24 hrs
            ///0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
            
        } else if currentTab == "Upcoming" {
            
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tomorrow = Date.distantFuture
            
            ///Filter Key
            let filterKey = "deadline"
            
            ///This will fetch task between today and tomorrow which is 24 hrs
            ///0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tomorrow, 0])
            
        } else if currentTab == "Failed" {
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            ///Filter Key
            let filterKey = "deadline"
            
            ///This will fetch task between today and tomorrow which is 24 hrs
            ///0-false, 1-true
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
        }
        
        ///Init Request with NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        if request.isEmpty {
            Text("No tasks found!")
                .font(.system(size: 16))
                .fontWeight(.light)
                .offset(y: 100)
        } else {
            ForEach(request, id: \.objectID) { object in
                self.content(object)
            }
        }
    }
}
