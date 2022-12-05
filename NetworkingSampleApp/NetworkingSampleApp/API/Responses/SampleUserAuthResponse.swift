//
//  SampleUserAuthResponse.swift
//  Networking sample app
//
//  Created by Tomas Cejka on 11.03.2021.
//

import Foundation

/// Data structure of sample API authentication response
struct SampleUserAuthResponse: Decodable {
    let token: String
}