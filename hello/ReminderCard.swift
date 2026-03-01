import SwiftUI

struct ReminderCard: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @Binding var reminder: Reminder
    @State private var showingEdit = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion button
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    reminderManager.toggleCompletion(reminder)
                }
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(reminder.isCompleted ? Color.green : Color(reminder.priority.color), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if reminder.isCompleted {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 16, height: 16)
                        
                        Image(systemName: "checkmark")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    // Category icon
                    Image(systemName: reminder.category.icon)
                        .font(.caption)
                        .foregroundColor(Color(reminder.category.color))
                        .padding(6)
                        .background(Color(reminder.category.color).opacity(0.15))
                        .cornerRadius(8)
                    
                    Text(reminder.title)
                        .font(.headline)
                        .strikethrough(reminder.isCompleted)
                        .foregroundColor(reminder.isCompleted ? .secondary : .primary)
                    
                    Spacer()
                    
                    // Priority badge
                    PriorityBadge(priority: reminder.priority)
                }
                
                if !reminder.notes.isEmpty {
                    Text(reminder.notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Due date
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(reminder.dueDate, style: .date)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(reminder.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .contextMenu {
            Button(action: { showingEdit = true }) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                withAnimation {
                    reminderManager.deleteReminder(reminder)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation {
                    reminderManager.deleteReminder(reminder)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                withAnimation {
                    reminderManager.toggleCompletion(reminder)
                }
            } label: {
                Label(reminder.isCompleted ? "Undo" : "Complete", systemImage: reminder.isCompleted ? "arrow.uturn.backward" : "checkmark")
            }
            .tint(reminder.isCompleted ? .gray : .green)
        }
        .sheet(isPresented: $showingEdit) {
            EditReminderView(reminder: $reminder)
                .environmentObject(reminderManager)
        }
    }
}

struct PriorityBadge: View {
    let priority: Priority
    
    var body: some View {
        Text(priority.title)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(priority.color).opacity(0.15))
            .foregroundColor(Color(priority.color))
            .cornerRadius(8)
    }
}
