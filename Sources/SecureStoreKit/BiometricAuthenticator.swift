//
//  BiometricAuthenticator.swift
//
//
//  Created by Kirill Titov on 02.07.2024.
//

import LocalAuthentication

public protocol BiometricAuthenticatorProtocol {
    var context: LAContext { get }
    func authenticateUser(completion: @escaping (Result<Void, Error>) -> Void)
}

public final class BiometricAuthenticator: BiometricAuthenticatorProtocol {
    public let context: LAContext

    public init(context: LAContext = LAContext()) {
        self.context = context
    }

    public func authenticateUser(completion: @escaping (Result<Void, Error>) -> Void) {
        context.localizedReason = "Authenticate to access your secure data"

        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: context.localizedReason) { success, evaluateError in
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(evaluateError ?? NSError(domain: "BiometricError", code: -1, userInfo: nil)))
                }
            }
        } else {
            completion(.failure(authError ?? NSError(domain: "BiometricError", code: -1, userInfo: nil)))
        }
    }
}
