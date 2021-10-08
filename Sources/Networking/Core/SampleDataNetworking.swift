//
//  SampleDataNetworking.swift
//  STRV_template Tests
//
//  Created by Tomas Cejka on 07.03.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Combine
import Foundation

// For NSDataAsset import
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

// MARK: - Implementation of networking which reads data from files

open class SampleDataNetworking: Networking {
    private let bundle: Bundle
    private let sessionId: String
    private lazy var requestCounter: [String: Int] = [:]
    private lazy var decoder = JSONDecoder()

    // need to inject bundle
    public init(with bundle: Bundle, sessionId: String) {
        self.bundle = bundle
        self.sessionId = sessionId
    }

    public func requestPublisher(for request: URLRequest) -> AnyPublisher<Response, NetworkError> {
        guard let sampleData = try? loadSampleData(for: request) else {
            fatalError("❌ Can't load data")
        }

        guard
            let statusCode = sampleData.statusCode,
            let url = request.url
        else {
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }

        guard
            let httpResponse = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: sampleData.responseHeaders
            )
        else {
            return Fail(error: NetworkError.unknown)
                .eraseToAnyPublisher()
        }

        return Just((sampleData.responseBody ?? Data(), httpResponse))
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}

// MARK: Read data from assets

private extension SampleDataNetworking {
    func loadSampleData(for request: URLRequest) throws -> EndpointRequestStorageModel? {
        // counting from 1, check storage request processing
        let count = requestCounter[request.identifier] ?? 1

        if let data = NSDataAsset(name: "\(sessionId)_\(request.identifier)_\(count)", bundle: bundle)?.data {
            // store info about next indexed api call
            requestCounter[request.identifier] = count + 1
            return try decoder.decode(EndpointRequestStorageModel.self, from: data)
        }
        // return previous response, if no more stored indexed api calls
        if count > 1, let data = NSDataAsset(name: "\(sessionId)_\(request.identifier)_\(count - 1)", bundle: bundle)?.data {
            return try decoder.decode(EndpointRequestStorageModel.self, from: data)
        }

        return nil
    }
}
