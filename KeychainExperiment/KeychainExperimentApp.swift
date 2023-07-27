import SwiftUI

@main
struct KeychainExperimentApp: App {
    @StateObject private var vm = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
