//
//  ContentView.swift
//  NetworkingSampleApp
//
//  Created by Matej Molnár on 28.01.2023.
//

import SwiftUI

enum Example: String, Hashable, CaseIterable {
    case authorization
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(Example.allCases, id: \.self) { screen in
                    NavigationLink(screen.rawValue.capitalized, value: Example.authorization)
                }
            }
            .navigationTitle("Examples")
            .navigationDestination(for: Example.self) { screen in
                switch screen {
                case .authorization:
                    AuthorizationView()
                }
            }
        }
    }
}
