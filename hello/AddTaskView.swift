import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var notes = ""
    @State private var priority: TaskPriority = .medium
    @State private var category: TaskCategory = .personal
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { pri in
                            HStack {
                                Circle()
                                    .fill(pri.color)
                                    .frame(width: 12, height: 12)
                                Text(pri.title)
                            }
                            .tag(pri)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Category") {
                    categoryGrid
                }
                
                Section("Due Date") {
                    DatePicker("Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                }
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let task = TaskItem(
                            title: title,
                            notes: notes,
                            priority: priority,
                            category: category,
                            dueDate: dueDate
                        )
                        appState.addTask(task)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var categoryGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
            ForEach(TaskCategory.allCases, id: \.self) { cat in
                CategoryButton(category: cat, isSelected: category == cat) {
                    category = cat
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct EditTaskView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    @Binding var task: TaskItem
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $task.title)
                    TextField("Notes", text: $task.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $task.priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { pri in
                            HStack {
                                Circle()
                                    .fill(pri.color)
                                    .frame(width: 12, height: 12)
                                Text(pri.title)
                            }
                            .tag(pri)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Category") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                        ForEach(TaskCategory.allCases, id: \.self) { cat in
                            CategoryButton(category: cat, isSelected: task.category == cat) {
                                task.category = cat
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Due Date") {
                    DatePicker("Date", selection: $task.dueDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                }
                
                Section {
                    Button(role: .destructive) {
                        appState.deleteTask(task)
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete Reminder")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Edit Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        appState.updateTask(task)
                        dismiss()
                    }
                    .disabled(task.title.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: TaskCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : category.color)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? category.color : category.color.opacity(0.15))
                    )
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? category.color : .secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddTaskView()
        .environmentObject(AppState())
}
