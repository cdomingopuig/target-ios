//
//  SignInViewModel.swift
//  target
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation

protocol SignInViewModelDelegate: class {
  func didUpdateState()
}

class SignInViewModelWithCredentials {
  
  var state: ViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: SignInViewModelDelegate?
  
  var email = ""
  
  var password = ""
  
  var hasValidEmail: Bool {
    return email.isEmailFormatted()
  }
  
  var hasValidPassword: Bool {
    return !password.isEmpty
  }
  
  var hasValidData: Bool {
    return hasValidEmail && hasValidPassword
  }
  
  func login() {
    state = .loading
    UserService.sharedInstance
      .login(email,
             password: password,
             success: { [weak self] in
              guard let self = self else { return }
              self.state = .idle
              AnalyticsManager.shared.identifyUser(with: self.email)
              AnalyticsManager.shared.log(event: Event.login)
              AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
             },
             failure: { [weak self] error in
              if let apiError = error as? APIError {
                self?.state = .error(apiError.firstError ?? "") // show the first error
              } else {
                self?.state = .error(error.localizedDescription)
              }
             })
  }
}
