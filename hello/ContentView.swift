import SwiftUI

struct ContentView: View {
    @EnvironmentObject var reminderManager: ReminderManager
    @State private var showingAddReminder = false
    @State private var selectedCategory: Category?
    @State private var searchText = ""
    
    var filteredReminders: [Reminder] {
        var result = reminderManager.reminders
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category filter
                    CategoryFilterView(selectedCategory: $selectedCategory)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    
                    // Reminders list
                    if filteredReminders.isEmpty {
                        EmptyStateView()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                // Pending section
                                if !reminderManager.pendingReminders.isEmpty {
                                    Section {
                                        ForEach(filteredReminders.filter { !$0.isCompleted }) { reminder in
                                            ReminderCard(reminder: reminder)
                                                .environmentObject(reminderManager)
                                        }
                                    } header: {
                                        SectionHeader(title: "To Do", count: reminderManager.pendingReminders.count)
                                    }
                                }
                                
                                // Completed section
                                if !reminderManager.completedReminders.isEmpty {
                                    Section {
                                        ForEach(filteredReminders.filter { $0.isCompleted }) { reminder in
                                            ReminderCard(reminder: reminder)
                                                .environmentObject(reminderManager)
                                        }
                                    } header: {
                                        SectionHeader(title: "Completed", count: reminderManager.completedReminders.count)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Reminders")
            .searchable(text: $searchText, prompt: "Search reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddReminder = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView()
                    .environmentObject(reminderManager)
            }
        }
    }
}

// MARK: - Category Filter
struct CategoryFilterView: View {
    @Binding var selectedCategory: Category?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterChip(title: "All", icon: "list.bullet", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(Category.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        color: Color(category.color)
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    var color: Color = .blue
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.2) : Color(.systemGray6))
            .foregroundColor(isSelected ? color : .secondary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 1.5)
            )
        }
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.blue)
                .clipShape(Capsule())
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - Empty State
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(.green.opacity(0.6))
            
            Text("All caught up!")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("No reminders yet.\nTap + to add one.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

#Preview {
    ContentView()
        .environmentObject(ReminderManager())
}
