//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by MAC on 06.11.2022.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    @Published var editTask: Task?
    
    func setUpTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "Basic"
            taskTitle = editTask.title ?? ""
            taskColor = editTask.color ?? "Yellow"
            taskDeadline = editTask.deadline ?? Date()
        }
    }

    func addTask(context: NSManagedObjectContext) -> Bool {
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func resetTaskData() {
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadline = Date()
    }
}
