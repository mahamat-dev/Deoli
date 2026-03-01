import SwiftUI

struct TaskCard: View {
    @EnvironmentObject var appState: AppState
    @State var task: TaskItem
    @State private var showingEdit = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion button
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    appState.toggleCompletion(task)
                }
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(task.isCompleted ? Color.green : task.priority.color, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if task.isCompleted {
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
                    Image(systemName: task.category.icon)
                        .font(.caption)
                        .foregroundColor(task.category.color)
                        .padding(6)
                        .background(task.category.color.opacity(0.15))
                        .cornerRadius(8)
                    
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted)
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                    
                    Spacer()
                    
                    PriorityBadge(priority: task.priority)
                }
                
                if !task.notes.isEmpty {
                    Text(task.notes)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                    Text(task.dueDate, style: .date)
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
                .stroke(task.isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .contextMenu {
            Button(action: { showingEdit = true }) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                withAnimation {
                    appState.deleteTask(task)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation {
                    appState.deleteTask(task)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button {
                withAnimation {
                    appState.toggleCompletion(task)
                }
            } label: {
                Label(task.isCompleted ? "Undo" : "Complete", systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark")
            }
            .tint(task.isCompleted ? .gray : .green)
        }
        .sheet(isPresented: $showingEdit) {
            EditTaskView(task: $task)
                .environmentObject(appState)
        }
    }
}

struct PriorityBadge: View {
    let priority: TaskPriority
    
    var body: some View {
        Text(priority.title)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priority.color.opacity(0.15))
            .foregroundColor(priority.color)
            .cornerRadius(8)
    }
}
