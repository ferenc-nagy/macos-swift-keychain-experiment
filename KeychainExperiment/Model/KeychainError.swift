import Foundation

enum KeychainError: Error {
    case noCredentials
    case unexpectedCredentialsData
    case unhandledError(status: OSStatus)
}
