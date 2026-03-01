import Foundation
import SwiftUI

// Priority Enum
enum TaskPriority: Int, CaseIterable, Codable {
    case low = 0
    case medium = 1
    case high = 2
    
    var title: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// Category Enum
enum TaskCategory: String, CaseIterable, Codable {
    case personal = "Personal"
    case work = "Work"
    case shopping = "Shopping"
    case health = "Health"
    
    var icon: String {
        switch self {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .shopping: return "cart.fill"
        case .health: return "heart.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .personal: return .purple
        case .work: return .blue
        case .shopping: return .orange
        case .health: return .pink
        }
    }
}

// Task Model
struct TaskItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var notes: String
    var isCompleted: Bool
    var priority: TaskPriority
    var category: TaskCategory
    var dueDate: Date
    
    init(title: String = "", notes: String = "", isCompleted: Bool = false, priority: TaskPriority = .medium, category: TaskCategory = .personal, dueDate: Date = Date()) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.priority = priority
        self.category = category
        self.dueDate = dueDate
    }
}

// App State (Manager)
class AppState: ObservableObject {
    @Published var tasks: [TaskItem] = []
    
    init() {
        // Sample data
        tasks = [
            TaskItem(title: "Buy groceries", notes: "Milk, bread, eggs", category: .shopping, priority: .high),
            TaskItem(title: "Team meeting", notes: "Discuss project timeline", category: .work, priority: .high),
            TaskItem(title: "Morning workout", notes: "30 minutes cardio", category: .health, priority: .medium),
            TaskItem(title: "Call mom", notes: "Weekly catch up", category: .personal, priority: .low)
        ]
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    func toggleCompletion(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    var pendingTasks: [TaskItem] {
        tasks.filter { !$0.isCompleted }
    }
    
    var completedTasks: [TaskItem] {
        tasks.filter { $0.isCompleted }
    }
}
