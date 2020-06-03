//
//  SignUpViewModel.swift
//  target
//
//  Created by German on 8/21/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

protocol SignUpViewModelDelegate: class {
  func didUpdateState()
}

class SignUpViewModelWithEmail {
  
  var state: ViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: SignUpViewModelDelegate?
  
  var name = ""
  
  var email = ""
  
  var password = ""
  
  var passwordConfirmation = ""
  
  var gender = ""
  
  var hasValidName: Bool {
    return !name.isEmpty
  }
  
  var hasValidEmail: Bool {
    return email.isEmailFormatted()
  }
  
  var hasValidPassword: Bool {
    return !password.isEmpty && password.count >= 6
  }
  
  var hasValidPasswordConfirmation: Bool {
    return password == passwordConfirmation
  }
  
  var hasValidGender: Bool {
    return genders.contains(gender.capitalized)
  }
  
  var hasValidData: Bool {
    return
      hasValidName && hasValidEmail && hasValidPassword && hasValidPasswordConfirmation && hasValidGender
  }
  
  func signup() {
    state = .loading
    UserService.sharedInstance.signup(
      name: name, email, password: password, gender: gender, avatar64: UIImage.random(),
      success: { [weak self] in
        guard let self = self else { return }
        self.state = .idle
        AnalyticsManager.shared.identifyUser(with: self.email)
        AnalyticsManager.shared.log(event: Event.registerSuccess(email: self.email))
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
