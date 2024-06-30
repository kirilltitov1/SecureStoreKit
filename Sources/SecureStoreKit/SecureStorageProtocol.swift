//
//  SecureStorageProtocol.swift
//
//
//  Created by Kirill Titov on 29.06.2024.
//

import Foundation

public protocol SecureStorageProtocol {
    func save(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void)
    func save(data: Data, for account: String) async -> Result<Void, Error>

    func load(for account: String, completion: @escaping (Result<Data?, Error>) -> Void)
    func load(for account: String) async -> Result<Data?, Error>

    func update(data: Data, for account: String, completion: @escaping (Result<Void, Error>) -> Void)
    func update(data: Data, for account: String) async -> Result<Void, Error>

    func delete(for account: String, completion: @escaping (Result<Void, Error>) -> Void)
    func delete(for account: String) async -> Result<Void, Error>
}
