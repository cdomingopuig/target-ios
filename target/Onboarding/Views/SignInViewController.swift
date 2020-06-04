//
//  SignInViewController.swift
//  target
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var passwordErrorLabel: UILabel!

  var viewModel: SignInViewModelWithCredentials!

  // MARK: - Lifecycle Events

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  // MARK: - Actions

  @IBAction func credentialsChanged(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case emailField:
      viewModel.email = newValue
    case passwordField:
      viewModel.password = newValue
    default: break
    }
  }

  @IBAction func editingDidEnd(_ sender: UITextField) {
    validateFields(sender)
  }

  @IBAction func tapOnSignInButton(_ sender: Any) {
    validateFields(nil)
    if viewModel.hasValidData {
      viewModel.login()
    }
  }

  @IBAction func tapOnSignUpButton(_ sender: Any) {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signUp, with: .changeRoot)
  }
  
  @IBAction func tapOnConnectFacebookButton(_ sender: Any) {
    viewModel.facebookLogin()
  }
}

extension SignInViewController: SignInViewModelDelegate {
  func didUpdateState() {
    switch viewModel.state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      setFieldError(input: emailField, error: true, message: "")
      setFieldError(input: passwordField, error: true, message: errorDescription)
    case .idle:
      UIApplication.hideNetworkActivity()
    }
  }
}

extension SignInViewController: UITextFieldDelegate {
  func validateFields(_ sender: UITextField?) {
    switch sender {
    case emailField:
      let error = !viewModel.hasValidEmail
      setFieldError(input: emailField, error: error, message: "Invalid email")
    case passwordField:
      let error = !viewModel.hasValidPassword
      setFieldError(input: passwordField, error: error, message: "Password can't be empty")
    default:
      validateFields(emailField)
      validateFields(passwordField)
    }
  }

  func setFieldError(input: UITextField, error: Bool, message: String) {
    let color = error ? UIColor.errorColor : UIColor.black
    let width = CGFloat(error ? 1 : 0.5)
    input.layer.borderColor = color?.cgColor
    input.layer.borderWidth = width
    let label = input == emailField ? emailErrorLabel : passwordErrorLabel
    label?.text = error ? message :  ""
  }
}
