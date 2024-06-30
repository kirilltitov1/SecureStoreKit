//
//  File.swift
//  
//
//  Created by Kirill Titov on 29.06.2024.
//

import Security
import LocalAuthentication

public final class KeychainService: SecureStorageProtocol {
    private let context: LAContext

    public init(context: LAContext = LAContext()) {
        self.context = context
    }

    // Метод для сохранения данных
    public func save(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence,
            nil
        )!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessControl as String: accessControl,
            kSecUseAuthenticationContext as String: context
        ]

        // Удаление существующего элемента перед добавлением нового
        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            completion(.success(()))
        } else {
            print("Keychain save error: \(status)")
            completion(.failure(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)))
        }
    }

    public func save(data: Data, for account: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            save(data: data, for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }

    // Метод для загрузки данных
    public func load(for account: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        context.localizedReason = "Authenticate to access your secure data"

        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: context.localizedReason) { success, evaluateError in
                if success {
                    let query: [String: Any] = [
                        kSecClass as String: kSecClassGenericPassword,
                        kSecAttrAccount as String: account,
                        kSecReturnData as String: kCFBooleanTrue!,
                        kSecMatchLimit as String: kSecMatchLimitOne,
                        kSecUseAuthenticationContext as String: self.context
                    ]

                    var dataTypeRef: AnyObject? = nil

                    let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

                    if status == errSecSuccess {
                        let data = dataTypeRef as? Data
                        completion(.success(data))
                    } else {
                        print("Keychain load error: \(status)")
                        completion(.failure(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)))
                    }
                } else {
                    print("Biometric evaluation failed: \(String(describing: evaluateError))")
                    completion(.failure(evaluateError ?? NSError(domain: "BiometricError", code: -1, userInfo: nil)))
                }
            }
        } else {
            print("Biometric policy evaluation failed: \(String(describing: authError))")
            completion(.failure(authError ?? NSError(domain: "BiometricError", code: -1, userInfo: nil)))
        }
    }

    public func load(for account: String) async -> Result<Data?, Error> {
        return await withCheckedContinuation { continuation in
            load(for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }

    // Метод для обновления данных
    public func update(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence,
            nil
        )!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessControl as String: accessControl,
            kSecUseAuthenticationContext as String: context
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecSuccess {
            completion(.success(()))
        } else if status == errSecItemNotFound {
            // Если элемент не найден, добавляем его как новый
            save(data: data, for: account, completion: completion)
        } else {
            print("Keychain update error: \(status)")
            completion(.failure(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)))
        }
    }

    public func update(data: Data, for account: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            update(data: data, for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }

    // Метод для удаления данных
    public func delete(for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)))
        }
    }

    public func delete(for account: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            delete(for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
