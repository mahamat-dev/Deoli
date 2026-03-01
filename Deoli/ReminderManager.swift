import Combine
import Foundation

class ReminderManager: ObservableObject {
    @Published var reminders: [Reminder] = []
    
    init() {
        // Sample data
        reminders = [
            Reminder(title: "Buy groceries", notes: "Milk, bread, eggs", priority: .high, category: .shopping),
            Reminder(title: "Team meeting", notes: "Discuss project timeline", priority: .high, category: .work),
            Reminder(title: "Morning workout", notes: "30 minutes cardio", priority: .medium, category: .health),
            Reminder(title: "Call mom", notes: "Weekly catch up", priority: .low, category: .personal)
        ]
    }
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func updateReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
    }
    
    func toggleCompletion(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isCompleted.toggle()
        }
    }
    
    var pendingReminders: [Reminder] {
        reminders.filter { !$0.isCompleted }
    }
    
    var completedReminders: [Reminder] {
        reminders.filter { $0.isCompleted }
    }
}
