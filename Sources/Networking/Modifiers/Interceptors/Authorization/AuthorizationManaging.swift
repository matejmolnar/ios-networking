//
//  AuthorizationManaging.swift
//  
//
//  Created by Dominika Gajdová on 20.12.2022.
//

import Foundation

public protocol AuthorizationManaging {
    var storage: any AuthorizationStorageManaging { get }
    func authorize(_ urlRequest: URLRequest) async throws -> URLRequest
    func refreshToken(_ token: String) async throws
}

extension AuthorizationManaging {
    public var storage: any AuthorizationStorageManaging {
        // Default storage, there will be a keychain solution as default.
        AuthorizationInMemoryStorage()
    }
    
    // Default authorize implementation.
    public func authorize(_ urlRequest: URLRequest) async throws -> URLRequest {
        if let authData = await storage.get(), !authData.isExpired {
            // append authentication header to request and return it
            return urlRequest
        }
        
        
        
        return urlRequest
    }
}
