//
//  SecureStorage.swift
//
//
//  Created by Kirill Titov on 29.06.2024.
//

import Foundation
import LocalAuthentication

public final class SecureStorageWrapper: SecureStorageProtocol {
    private let storage: SecureStorageProtocol

    init(storageType: StorageType, context: LAContext = LAContext()) {
        let authenticator: BiometricAuthenticatorProtocol = BiometricAuthenticator(context: context)
        switch storageType {
        case .keychain:
            self.storage = KeychainService(authenticator: authenticator)
        case .userDefaults:
            self.storage = UserDefaultsService()
        }
    }

    public func save(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        storage.save(data: data, for: account, completion: completion)
    }

    public func save(data: Data, for account: String) async -> Result<Void, Error> {
        return await storage.save(data: data, for: account)
    }

    public func load(for account: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        storage.load(for: account, completion: completion)
    }

    public func load(for account: String) async -> Result<Data?, Error> {
        return await storage.load(for: account)
    }

    public func update(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        storage.update(data: data, for: account, completion: completion)
    }

    public func update(data: Data, for account: String) async -> Result<Void, Error> {
        return await storage.update(data: data, for: account)
    }

    public func delete(for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        storage.delete(for: account, completion: completion)
    }

    public func delete(for account: String) async -> Result<Void, Error> {
        return await storage.delete(for: account)
    }
}
