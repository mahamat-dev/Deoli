import SwiftUI

@main
struct DeoliApp: App {
    @StateObject private var reminderManager = ReminderManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(reminderManager)
        }
    }
}
