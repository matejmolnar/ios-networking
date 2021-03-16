//
//  APIManager.swift
//  STRV_template
//
//  Created by Jan Pacek on 04.12.2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Foundation
import Combine

public class APIManager: APIManaging {
    
    private lazy var backgroundQueue = DispatchQueue(label: "com.strv.apimanager")
    
    private let network: Networking
    private let requestAdapters: [RequestAdapting]
    private let requestRetrier: RequestRetrying
    private let responseProcessors: [ResponseProcessing]

    public init(
        network: Networking = URLSession(configuration: .default),
        requestAdapters: [RequestAdapting] = [],
        responseProcessors: [ResponseProcessing] = [],
        requestRetrier: RequestRetrying = RequestRetrier(RequestRetrier.Configuration(retryLimit: 3))
    ) {
        self.network = network
        self.requestAdapters = requestAdapters
        self.responseProcessors = responseProcessors
        self.requestRetrier = requestRetrier
    }

    public func request(_ endpoint: Requestable) -> AnyPublisher<Response, Error> {
        
        // create idenfier of api call
        let requestIdentifier = "\(endpoint.identifier)_\(Date().timeIntervalSince1970)"
        return request(EndpointRequest(identifier: requestIdentifier, endpoint: endpoint))
    }
    
    public func request<DecodableResponse: Decodable>(_ endpoint: Requestable, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<DecodableResponse, Error> {
        request(endpoint)
            .tryMap { try decoder.decode(DecodableResponse.self, from: $0.data) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private extenstion to use same api call for retry
private extension APIManager {
    func request(_ endpointRequest: EndpointRequest) -> AnyPublisher<Response, Error> {
        
        // create url request
        Just(endpointRequest.endpoint)
            // work in background
            .receive(on: backgroundQueue)
            // create request
            .tryMap { try $0.asRequest() }
            // adapt request
            .flatMap { request -> AnyPublisher<URLRequest, Error> in
                let requestPublisher = Just(request).setFailureType(to: Error.self).eraseToAnyPublisher()
                return self.requestAdapters.reduce(requestPublisher) { $1.adapt($0, for: endpointRequest) }
            }
            // call request
            .flatMap { urlRequest -> AnyPublisher<(URLRequest, Response), Error> in
                return self.network.requestPublisher(for: urlRequest)
                    .mapError { $0 as Error }
                    .map { (urlRequest, $0) }
                    .eraseToAnyPublisher()
            }
            // process response
            .flatMap { (request, response) -> AnyPublisher<Response, Error> in
                let responsePublisher = Just(response).setFailureType(to: Error.self).eraseToAnyPublisher()
                return self.responseProcessors.reduce(responsePublisher) { $1.process($0, with: request, for: endpointRequest) }
            }
            // retry
            .catch { error -> AnyPublisher<Response, Error> in
                self.requestRetrier.retry(self.request(endpointRequest), with: error, for: endpointRequest)
            }
            // move to main thread
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
