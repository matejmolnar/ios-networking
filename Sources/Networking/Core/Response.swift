//
//  Response.swift
//
//  Created by Tomas Cejka on 11.03.2021.
//

import Foundation

// MARK: - Defines complete response

/// Renaming `URLSession.shared.data` task output type
public typealias Response = (data: Data, response: URLResponse)
