import Foundation

class KeychainService {
    static var shared = KeychainService()
    
    private init() {
    }
    
    func getCredentials() throws -> Credentials {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: "TestingKeychainAccess",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.noCredentials
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let existingItem = item as? [String: Any],
              let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: String.Encoding.utf8),
              let username = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedCredentialsData
        }
        
        return Credentials(username: username, password: password)
    }
    
    func storeCredentials(_ credentials: Credentials) throws {
        if try areCredentialsExist() {
            print("Credentials exist, will update")
            try updateCredentials(credentials)
        } else {
            print("Credentials does not exist, will create")
            try createCredentials(credentials)
        }
    }
    
    func deleteCredentials() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: "TestingKeychainAccess",
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
    
    private func areCredentialsExist() throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: "TestingKeychainAccess",
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        
        return status != errSecItemNotFound
    }
    
    private func createCredentials(_ credentials: Credentials) throws {
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: password,
            kSecAttrLabel as String: "TestingKeychainAccess"
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    private func updateCredentials(_ credentials: Credentials) throws {
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrLabel as String: "TestingKeychainAccess",
        ]
        
        let attributes: [String: Any] = [
            kSecAttrAccount as String: account,
            kSecValueData as String: password,
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noCredentials }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
}
