import SwiftUI

struct AddReminderView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var notes = ""
    @State private var priority: Priority = .medium
    @State private var category: Category = .personal
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
                        ForEach(Priority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(Color(priority.color))
                                    .frame(width: 12, height: 12)
                                Text(priority.title)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Category") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                        ForEach(Category.allCases, id: \.self) { cat in
                            CategoryButton(category: cat, isSelected: category == cat) {
                                category = cat
                            }
                        }
                    }
                    .padding(.vertical, 8)
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
                        let reminder = Reminder(
                            title: title,
                            notes: notes,
                            priority: priority,
                            category: category,
                            dueDate: dueDate
                        )
                        reminderManager.addReminder(reminder)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct EditReminderView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @Environment(\.dismiss) var dismiss
    @Binding var reminder: Reminder
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $reminder.title)
                    TextField("Notes", text: $reminder.notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $reminder.priority) {
                        ForEach(Priority.allCases, id: \.self) { priority in
                            HStack {
                                Circle()
                                    .fill(Color(priority.color))
                                    .frame(width: 12, height: 12)
                                Text(priority.title)
                            }
                            .tag(priority)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Category") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 12) {
                        ForEach(Category.allCases, id: \.self) { cat in
                            CategoryButton(category: cat, isSelected: reminder.category == cat) {
                                reminder.category = cat
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Due Date") {
                    DatePicker("Date", selection: $reminder.dueDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.graphical)
                }
                
                Section {
                    Button(role: .destructive) {
                        reminderManager.deleteReminder(reminder)
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
                        reminderManager.updateReminder(reminder)
                        dismiss()
                    }
                    .disabled(reminder.title.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : Color(category.color))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? Color(category.color) : Color(category.color).opacity(0.15))
                    )
                
                Text(category.rawValue)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color(category.color) : .secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    AddReminderView()
        .environmentObject(ReminderManager())
}
