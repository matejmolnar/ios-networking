//
//  AuthorizationView.swift
//  NetworkingSampleApp
//
//  Created by Matej Molnár on 28.01.2023.
//

import SwiftUI

struct AuthorizationView: View {
    @StateObject private var viewModel = AuthorizationViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            loginButton
            
            getStatusButton
        }
        .navigationTitle("Authorization")
    }
}

private extension AuthorizationView {
    var loginButton: some View {
        Button {
            Task {
                try await viewModel.login(
                    email: SampleAPIConstants.validEmail,
                    password: SampleAPIConstants.validPassword
                )
            }
        } label: {
            Text("Login")
        }
    }
    
    var getStatusButton: some View {
        Button {
            Task {
                try await viewModel.checkAuthorizationStatus()
            }
        } label: {
            Text("Get Status")
        }
    }
}
