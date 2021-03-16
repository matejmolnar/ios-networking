//
//  EndpointRequest.swift
//  STRV_template
//
//  Created by Tomas Cejka on 04.03.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Foundation

public struct EndpointRequest: Identifiable {
    public let identifier: String
    public let endpoint: Requestable
}
