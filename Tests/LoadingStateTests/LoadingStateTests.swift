/**
 * LoadingState
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

import XCTest
@testable import LoadingState

typealias State = LoadingState<Int, Error>

enum Error: Swift.Error, Equatable {
    
    case systemFailure, timeout
}

final class LoadingStateTests: XCTestCase {
    
    private func states() -> (idle: State, inProgress: State, success: State, failure: State) {
        (.idle, .inProgress, .success(42), .failure(.systemFailure))
    }

    func testValue() {
        XCTAssertNil(State.idle.value)
        XCTAssertNil(State.inProgress.value)
        XCTAssertEqual(State.success(42).value, 42)
        XCTAssertNil(State.failure(.systemFailure).value)
    }
    
    func testIsIdle() {
        XCTAssertTrue(State.idle.isIdle)
        XCTAssertFalse(State.inProgress.isIdle)
        XCTAssertFalse(State.success(42).isIdle)
        XCTAssertFalse(State.failure(Error.systemFailure).isIdle)
    }
    
    func testIsInProgress() {
        XCTAssertFalse(State.idle.isInProgress)
        XCTAssertTrue(State.inProgress.isInProgress)
        XCTAssertFalse(State.success(42).isInProgress)
        XCTAssertFalse(State.failure(Error.systemFailure).isInProgress)
    }
    
    func testIsSuccessful() {
        XCTAssertFalse(State.idle.isSuccessful)
        XCTAssertFalse(State.inProgress.isSuccessful)
        XCTAssertTrue(State.success(42).isSuccessful)
        XCTAssertFalse(State.failure(Error.systemFailure).isSuccessful)
    }
    
    func testIsFailed() {
        XCTAssertFalse(State.idle.isFailed)
        XCTAssertFalse(State.inProgress.isFailed)
        XCTAssertFalse(State.success(42).isFailed)
        XCTAssertTrue(State.failure(Error.systemFailure).isFailed)
    }
    
    func testResult() {
        let success = Result<Int, Error>.success(42)
        let failure = Result<Int, Error>.failure(.systemFailure)
        XCTAssertEqual(LoadingState(success), .success(42))
        XCTAssertEqual(LoadingState(failure), .failure(.systemFailure))
        XCTAssertEqual(LoadingState.finished(success), .success(42))
        XCTAssertEqual(LoadingState.finished(failure), .failure(.systemFailure))
    }
    
    func testEquatable() {
        XCTAssertTrue(State.idle == .idle)
        XCTAssertTrue(State.idle != .inProgress)
        XCTAssertTrue(State.idle != .success(42))
        XCTAssertTrue(State.idle != .failure(.systemFailure))
        
        XCTAssertTrue(State.inProgress != .idle)
        XCTAssertTrue(State.inProgress == .inProgress)
        XCTAssertTrue(State.inProgress != .success(42))
        XCTAssertTrue(State.inProgress != .failure(.systemFailure))
        
        XCTAssertTrue(State.success(42) != .idle)
        XCTAssertTrue(State.success(42) != .inProgress)
        XCTAssertTrue(State.success(42) == .success(42))
        XCTAssertTrue(State.success(42) != .failure(.systemFailure))
        
        XCTAssertTrue(State.failure(.systemFailure) != .idle)
        XCTAssertTrue(State.failure(.systemFailure) != .inProgress)
        XCTAssertTrue(State.failure(.systemFailure) != .success(42))
        XCTAssertTrue(State.failure(.systemFailure) == .failure(.systemFailure))
    }
}
