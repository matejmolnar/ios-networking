//
//  Networking+URLSession.swift
//  STRV_template
//
//  Created by Jan Pacek on 04.12.2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Foundation
import Combine

// MARK: - Implementation of networking for URLSession

extension URLSession: Networking {
    public func requestPublisher(for request: URLRequest) -> AnyPublisher<Response, NetworkError> {
        dataTaskPublisher(for: request)
            .mapError(mapToNetworkError(_:))
            .eraseToAnyPublisher()
    }
}

private extension URLSession {
    func mapToNetworkError(_ error: URLError) -> NetworkError {
        .underlaying(error)
    }
}
