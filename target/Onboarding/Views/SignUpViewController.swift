//
//  SignUpViewController.swift
//  target
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var nameError: UILabel!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var emailError: UILabel!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordError: UILabel!
  @IBOutlet weak var passwordConfirmationField: UITextField!
  @IBOutlet weak var passwordConfirmationError: UILabel!
  @IBOutlet weak var genderField: UITextField!
  @IBOutlet weak var genderError: UILabel!
  
  var viewModel: SignUpViewModelWithEmail!
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGenderPicker()
    viewModel.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func formEditingChange(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case nameField:
      viewModel.name = newValue
    case emailField:
      viewModel.email = newValue
    case passwordField:
      viewModel.password = newValue
    case passwordConfirmationField:
      viewModel.passwordConfirmation = newValue
    default: break
    }
  }
  
  @IBAction func editingDidEnd(_ sender: UITextField) {
    validateFields(sender)
  }
  
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    validateFields(nil)
    if viewModel.hasValidData {
      viewModel.signup()
    }
  }
  
  @IBAction func tapOnSignInButton(_ sender: Any) {
    AppNavigator.shared.navigate(to: OnboardingRoutes.signIn, with: .changeRoot)
  }
  
  func createGenderPicker() {
    let genderPicker = UIPickerView()
    genderPicker.delegate = self
    genderField.inputView = genderPicker
  }
}

extension SignUpViewController: SignUpViewModelDelegate {
  func didUpdateState() {
    switch viewModel.state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      setFieldError(input: emailField, label: emailError, error: true, message: errorDescription)
    case .idle:
      UIApplication.hideNetworkActivity()
    }
  }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return genders.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return genders[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    genderField.text = genders[row].uppercased()
    viewModel.gender = genders[row].lowercased()
    validateFields(genderField)
  }
}

extension SignUpViewController: UITextFieldDelegate {
   func validateFields(_ sender: UITextField?) {
     switch sender {
     case nameField:
       let error = !viewModel.hasValidName
       setFieldError(input: nameField, label: nameError, error: error, message: "you forgot to put your name!")
     case emailField:
       let error = !viewModel.hasValidEmail
       setFieldError(input: emailField, label: emailError, error: error, message: "oops! this email is not valid")
     case passwordField:
       let error = !viewModel.hasValidPassword
       setFieldError(input: passwordField, label: passwordError, error: error, message: "the password must be 6 characters long")
     case passwordConfirmationField:
       let error = !viewModel.hasValidPasswordConfirmation
       setFieldError(input: passwordConfirmationField, label: passwordConfirmationError, error: error, message: "passwords don’t match")
     case genderField:
       let error = !viewModel.hasValidGender
       setFieldError(input: genderField, label: genderError, error: error, message: "you forgot to select your gender!")
     default:
       validateFields(nameField)
       validateFields(emailField)
       validateFields(passwordField)
       validateFields(passwordConfirmationField)
       validateFields(genderField)
     }
   }
   
   func setFieldError(input: UITextField, label: UILabel, error: Bool, message: String) {
     let color = error ? UIColor.errorColor  : UIColor.black
     let width = CGFloat(error ? 1 : 0.5)
     input.layer.borderColor = color?.cgColor
     input.layer.borderWidth = width
     label.text = error ? message :  ""
   }
}
