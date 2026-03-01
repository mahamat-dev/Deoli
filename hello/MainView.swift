import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddTask = false
    @State private var selectedCategory: TaskCategory?
    @State private var searchText = ""
    
    var filteredTasks: [TaskItem] {
        var result = appState.tasks
        
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
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    categoryFilter
                    
                    if filteredTasks.isEmpty {
                        emptyState
                    } else {
                        taskList
                    }
                }
            }
            .navigationTitle("Reminders")
            .searchable(text: $searchText, prompt: "Search reminders")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
                    .environmentObject(appState)
            }
        }
    }
    
    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                FilterChip(title: "All", icon: "list.bullet", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(TaskCategory.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        icon: category.icon,
                        isSelected: selectedCategory == category,
                        color: category.color
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    // MARK: - Task List
    private var taskList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if !appState.pendingTasks.isEmpty {
                    Section {
                        ForEach(filteredTasks.filter { !$0.isCompleted }) { task in
                            TaskCard(task: task)
                        }
                    } header: {
                        SectionHeader(title: "To Do", count: appState.pendingTasks.count)
                    }
                }
                
                if !appState.completedTasks.isEmpty {
                    Section {
                        ForEach(filteredTasks.filter { $0.isCompleted }) { task in
                            TaskCard(task: task)
                        }
                    } header: {
                        SectionHeader(title: "Completed", count: appState.completedTasks.count)
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
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

// MARK: - Filter Chip
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

#Preview {
    MainView()
        .environmentObject(AppState())
}
