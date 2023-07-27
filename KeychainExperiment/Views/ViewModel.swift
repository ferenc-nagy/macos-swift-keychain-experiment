import Foundation
import Combine

class ViewModel: ObservableObject {
    @Published var credentials: Credentials?
    @Published var username: String = ""
    @Published var password: String = ""
    
    private var keychainService = KeychainService.shared
    
    init() {
        refreshCredentials()
    }
    
    func refreshCredentials() {
        do {
            credentials = try keychainService.getCredentials()
        } catch KeychainError.noCredentials {
            credentials = nil
        } catch let error {
            print("Error fetching credentials: \(error.localizedDescription)")
            credentials = nil
        }
    }
    
    func updateCredentials() {
        do {
            try keychainService.storeCredentials(Credentials(username: username, password: password))
            refreshCredentials()
        } catch let error {
            print("Error updating credentials: \(error.localizedDescription)")
            credentials = nil
        }
    }
    
    func deleteCredentials() {
        do {
            try keychainService.deleteCredentials()
            refreshCredentials()
        } catch let error {
            print("Error deleting credentials: \(error.localizedDescription)")
            credentials = nil
        }
    }
}
