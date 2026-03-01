import Foundation

enum Priority: Int, CaseIterable, Codable {
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
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}

enum Category: String, CaseIterable, Codable {
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
    
    var color: String {
        switch self {
        case .personal: return "purple"
        case .work: return "blue"
        case .shopping: return "orange"
        case .health: return "pink"
        }
    }
}

struct Reminder: Identifiable, Codable {
    var id = UUID()
    var title: String
    var notes: String
    var isCompleted: Bool
    var priority: Priority
    var category: Category
    var dueDate: Date
    
    init(title: String = "", notes: String = "", isCompleted: Bool = false, priority: Priority = .medium, category: Category = .personal, dueDate: Date = Date()) {
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.priority = priority
        self.category = category
        self.dueDate = dueDate
    }
}
