//
//  LoginViewModel.swift
//  EazyShop
//
//  Created by Cesar Rojas on 8/5/24.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isValidEmail: Bool = true
    @Published var hasStartedTyping: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $email
            .sink { [weak self] newValue in
                self?.isValidEmail = newValue.isValidEmail()
                if !newValue.isEmpty {
                    self?.hasStartedTyping = true
                }
            }
            .store(in: &cancellables)
    }
    
    var errorText: some View {
        if hasStartedTyping && !isValidEmail {
            return AnyView(
                Text(Constants.Text.confirmEmail)
                    .font(.custom(Constants.Fonts.metropolisRegular, size: 11))
                    .foregroundColor(Constants.Colors.redError)
                    .textSelection(.disabled)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var overlayColor: Color {
        if hasStartedTyping {
            return isValidEmail ? Color(.clear) : Constants.Colors.redError
        } else {
            return Color(.clear)
        }
    }
    
    var nameCheckImage: some View {
        if !name.isEmpty {
            return AnyView(
                Image(Constants.Images.check)
                    .foregroundColor(.green)
                    .padding(.trailing, 8)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    var mailCheckImage: some View {
        if hasStartedTyping && !isValidEmail {
            return AnyView(
                Image(Constants.Images.close)
                    .foregroundColor(.red)
                    .padding(.trailing, 8)
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}

