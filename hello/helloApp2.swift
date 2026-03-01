import SwiftUI

@main
struct helloApp2: App {
    @State private var reminderManager = ReminderManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(reminderManager)
        }
    }
}
