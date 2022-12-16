//
//  SampleViewModel.swift
//  NetworkingSampleApp
//
//  Created by Dominika Gajdová on 06.12.2022.
//

import Foundation
import Networking
import OSLog

final class SampleViewModel {
    private let apiManager: APIManager = {
        let loggingInterceptor = LoggingInterceptor()
        var responseProcessors: [ResponseProcessing] = [StatusCodeProcessor(), loggingInterceptor]
        
        #if DEBUG
        responseProcessors.append(EndpointRequestStorageProcessor())
        #endif
        
        return APIManager(
            urlSession: URLSession.shared,
            requestAdapters: [loggingInterceptor],
            responseProcessors: responseProcessors,
            errorProcessors: [SampleErrorProcessor(), loggingInterceptor]
        )
    }()
    
    func runNetworkingExamples() {
        
        Task {
            do {
                //HTTP 200
                try await loadUserList()
                
                // HTTP 400
                try await login(
                    email: SampleAPIConstants.validEmail,
                    password: SampleAPIConstants.noPassword
                )
            }
        }
    }
    
    func loadUserList() async throws {
        try await apiManager.request(
            SampleUserRouter.users(page: 2)
        )
    }
    
    func login(email: String?, password: String?) async throws {
        let request = SampleUserAuthRequest(email: email, password: password)
        try await apiManager.request(
            SampleUserRouter.loginUser(user: request)
        )
    }
}
