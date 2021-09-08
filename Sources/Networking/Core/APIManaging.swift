//
//  APIManaging.swift
//  STRV_template
//
//  Created by Jan Pacek on 04.12.2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Combine
import Foundation

// MARK: - Defines api managing

public protocol APIManaging {
    func request(_ endpoint: Requestable) -> AnyPublisher<Response, Error>
    func request<Body: Decodable>(_ endpoint: Requestable, decoder: JSONDecoder) -> AnyPublisher<Body, Error>
}

// MARK: - Provide request with default json decoder

public extension APIManaging {
    func request<Body: Decodable>(_ endpoint: Requestable) -> AnyPublisher<Body, Error> {
        request(endpoint, decoder: JSONDecoder())
    }
}

// MARK: - Provide request with default decoding

public extension APIManaging {
    func request<DecodableResponse: Decodable>(_ endpoint: Requestable, decoder: JSONDecoder) -> AnyPublisher<DecodableResponse, Error> {
        request(endpoint)
            .tryMap { try decoder.decode(DecodableResponse.self, from: $0.data) }
            .eraseToAnyPublisher()
    }
}

// TODO: JK idea about retry approach
/*
 apiManager.request(request, retryCount: 5, retryDelay: 3) { error in
   return true
 }
 */
