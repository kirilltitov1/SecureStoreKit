//
//  MockLAContext.swift
//
//
//  Created by Kirill Titov on 29.06.2024.
//

import LocalAuthentication

class MockLAContext: LAContext {
    var canEvaluatePolicyResponse = true
    var evaluatePolicySuccess = true
    var evaluatePolicyError: Error?

    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        return canEvaluatePolicyResponse
    }

    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(evaluatePolicySuccess, evaluatePolicyError)
    }
}
