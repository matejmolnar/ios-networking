//
//  Networking.swift
//  STRV_template
//
//  Created by Jan Pacek on 04.12.2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Foundation
import Combine

// Networking is the thing that can make a request - URLSession or some mock class that only reads testing responses
public protocol Networking {
    func requestPublisher(for: URLRequest) -> AnyPublisher<Response, NetworkError>
}
