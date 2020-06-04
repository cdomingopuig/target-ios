//
//  SignInViewModel.swift
//  target
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import FBSDKLoginKit

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
  
  func facebookLogin() {
    guard let viewController = delegate as? UIViewController else { return }
    let facebookKey = ConfigurationManager.getValue(for: "FacebookKey")
    assert(!(facebookKey?.isEmpty ?? false), "Value for FacebookKey not found")
    
    state = .loading
    let fbLoginManager = LoginManager()
    //Logs out before login, in case user changes facebook accounts
    fbLoginManager.logOut()
    fbLoginManager.logIn(permissions: ["email"],
                         from: viewController,
                         handler: checkFacebookLoginRequest)
  }
  
  // MARK: Facebook callback methods
  
  func facebookLoginRequestSucceded() {
    //Optionally store params (facebook user data) locally.
    guard let token = AccessToken.current else {
      return
    }
    //This fails with 404 since this endpoint is not implemented in the API base
    UserService.sharedInstance.loginWithFacebook(
      token: token.tokenString,
      success: { [weak self] in
        self?.state = .idle
        AppNavigator.shared.navigate(to: HomeRoutes.home, with: .changeRoot)
      },
      failure: { [weak self] error in
        self?.state = .error(error.localizedDescription)
    })
  }
  
  func facebookLoginRequestFailed(reason: String, cancelled: Bool = false) {
    state = cancelled ? .idle : .error(reason)
  }
  
  func checkFacebookLoginRequest(result: LoginManagerLoginResult?, error: Error?) {
    guard let result = result, error == nil else {
      facebookLoginRequestFailed(reason: error?.localizedDescription ?? "")
      return
    }
    if result.isCancelled {
      facebookLoginRequestFailed(reason: "User cancelled", cancelled: true)
    } else if !result.grantedPermissions.contains("email") {
      facebookLoginRequestFailed(
        reason: """
          It seems that you haven't allowed Facebook to provide your email address.
        """
      )
    } else {
      facebookLoginRequestSucceded()
    }
  }
}
