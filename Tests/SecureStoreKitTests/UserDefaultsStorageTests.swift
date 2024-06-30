//
//  UserDefaultsStorageTests.swift
//
//
//  Created by Kirill Titov on 29.06.2024.
//

import XCTest
@testable import SecureStoreKit

class UserDefaultsStorageTests: XCTestCase {

    var userDefaultsStorage: UserDefaultsService!

    override func setUpWithError() throws {
        userDefaultsStorage = UserDefaultsService()
    }

    override func tearDownWithError() throws {
        let expectation = self.expectation(description: "Delete data")
        Task {
            _ = await userDefaultsStorage.delete(for: "test_account")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        userDefaultsStorage = nil
    }

    func testSaveDataWithUserDefaults() async {
        // Arrange
        let testData = "test_data".data(using: .utf8)!

        // Act
        let saveResult = await userDefaultsStorage.save(data: testData, for: "test_account")

        // Assert
        switch saveResult {
        case .success():
            // Load data to verify save
            let loadResult = await userDefaultsStorage.load(for: "test_account")
            switch loadResult {
            case .success(let loadedData):
                XCTAssertNotNil(loadedData, "Data should not be nil")
                XCTAssertEqual(loadedData, testData, "Loaded data should be equal to saved data")
            case .failure(let error):
                XCTFail("Load failed with error: \(error)")
            }
        case .failure(let error):
            XCTFail("Save failed with error: \(error)")
        }
    }

    func testLoadDataWithUserDefaults() async {
        // Arrange
        let testData = "test_data".data(using: .utf8)!
        _ = await userDefaultsStorage.save(data: testData, for: "test_account")

        // Act
        let loadResult = await userDefaultsStorage.load(for: "test_account")

        // Assert
        switch loadResult {
        case .success(let loadedData):
            XCTAssertNotNil(loadedData, "Data should not be nil")
            XCTAssertEqual(loadedData, testData, "Loaded data should be equal to saved data")
        case .failure(let error):
            XCTFail("Load failed with error: \(error)")
        }
    }

    func testUpdateDataWithUserDefaults() async {
        // Arrange
        let oldData = "old_data".data(using: .utf8)!
        let newData = "new_data".data(using: .utf8)!
        _ = await userDefaultsStorage.save(data: oldData, for: "test_account")

        // Act
        let updateResult = await userDefaultsStorage.update(data: newData, for: "test_account")

        // Assert
        switch updateResult {
        case .success():
            // Load data to verify update
            let loadResult = await userDefaultsStorage.load(for: "test_account")
            switch loadResult {
            case .success(let loadedData):
                XCTAssertNotNil(loadedData, "Data should not be nil")
                XCTAssertEqual(loadedData, newData, "Loaded data should be equal to updated data")
            case .failure(let error):
                XCTFail("Load failed with error: \(error)")
            }
        case .failure(let error):
            XCTFail("Update failed with error: \(error)")
        }
    }

    func testDeleteDataWithUserDefaults() async {
        // Arrange
        let testData = "test_data".data(using: .utf8)!
        _ = await userDefaultsStorage.save(data: testData, for: "test_account")

        // Act
        let deleteResult = await userDefaultsStorage.delete(for: "test_account")

        // Assert
        switch deleteResult {
        case .success():
            // Load data to verify delete
            let loadResult = await userDefaultsStorage.load(for: "test_account")
            switch loadResult {
            case .success(let loadedData):
                XCTAssertNil(loadedData, "Data should be nil after deletion")
            case .failure(let error):
                XCTFail("Load failed with error: \(error)")
            }
        case .failure(let error):
            XCTFail("Delete failed with error: \(error)")
        }
    }
}
