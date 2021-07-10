/**
 * LoadingState
 * Copyright (c) Luca Meghnagi 2021
 * MIT license, see LICENSE file for details
 */

public extension LoadingState {
    
    init(_ result: Result<Success, Failure>) {
        switch result {
        case .success(let value):
            self = .success(value)
        case .failure(let error):
            self = .failure(error)
        }
    }
    
    static func finished(_ result: Result<Success, Failure>) -> Self {
        LoadingState(result)
    }
}
