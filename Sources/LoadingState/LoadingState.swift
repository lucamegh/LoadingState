/**
 * LoadingState
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

public enum LoadingState<Success, Failure: Error> {
    
    case idle
    
    case inProgress
    
    case success(Success)
    
    case failure(Failure)
}

public extension LoadingState {
    
    var value: Success? {
        guard case .success(let value) = self else { return nil }
        return value
    }
    
    var isIdle: Bool {
        guard case .idle = self else { return false }
        return true
    }
    
    var isInProgress: Bool {
        guard case .inProgress = self else { return false }
        return true
    }
    
    var isSuccessful: Bool {
        guard case .success = self else { return false }
        return true
    }
    
    var isFailed: Bool {
        guard case .failure = self else { return false }
        return true
    }
}

public extension LoadingState {
    
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> LoadingState<NewSuccess, Failure> {
        switch self {
        case .idle:
            return .idle
        case .inProgress:
            return .inProgress
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }

    func mapError<NewFailure>(_ transform: (Failure) -> NewFailure) -> LoadingState<Success, NewFailure> {
        switch self {
        case .idle:
            return .idle
        case .inProgress:
            return .inProgress
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(transform(error))
        }
    }
    
    func flatMap<NewSuccess>(_ transform: (Success) -> LoadingState<NewSuccess, Failure>) -> LoadingState<NewSuccess, Failure> {
        switch self {
        case .idle:
            return .idle
        case .inProgress:
            return .inProgress
        case .success(let value):
            return transform(value)
        case .failure(let error):
            return .failure(error)
        }
    }

    func flatMapError<NewFailure>(_ transform: (Failure) -> LoadingState<Success, NewFailure>) -> LoadingState<Success, NewFailure> {
        switch self {
        case .idle:
            return .idle
        case .inProgress:
            return .inProgress
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return transform(error)
        }
    }
}

extension LoadingState: Equatable where Success: Equatable, Failure: Equatable {}
