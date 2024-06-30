//
//  UserDefaultsService.swift
//
//
//  Created by Kirill Titov on 29.06.2024.
//

import Foundation

public final class UserDefaultsService: SecureStorageProtocol {

    public func save(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        UserDefaults.standard.set(data, forKey: account)
        completion(.success(()))
    }

    public func save(data: Data, for account: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            save(data: data, for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func load(for account: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        if let data = UserDefaults.standard.data(forKey: account) {
            completion(.success(data))
        } else {
            completion(.success(nil))
        }
    }

    public func load(for account: String) async -> Result<Data?, Error> {
        return await withCheckedContinuation { continuation in
            load(for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func update(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        save(data: data, for: account, completion: completion)
    }

    public func update(data: Data, for account: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            update(data: data, for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func delete(for account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        UserDefaults.standard.removeObject(forKey: account)
        completion(.success(()))
    }

    public func delete(for account: String) async -> Result<Void, Error> {
        return await withCheckedContinuation { continuation in
            delete(for: account) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
