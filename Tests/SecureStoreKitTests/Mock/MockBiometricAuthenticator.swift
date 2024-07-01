//
//  File.swift
//  
//
//  Created by Kirill Titov on 02.07.2024.
//

@testable import SecureStoreKit
import LocalAuthentication

class MockBiometricAuthenticator: BiometricAuthenticatorProtocol {
    var context: LAContext
    var shouldAuthenticateSuccessfully: Bool = true

    init() {
        self.context = LAContext()
    }

    func authenticateUser(completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldAuthenticateSuccessfully {
            completion(.success(()))
        } else {
            let error = NSError(domain: "BiometricError", code: -1, userInfo: nil)
            completion(.failure(error))
        }
    }
}
