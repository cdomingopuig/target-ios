//
//  UINavigationControllerExtension.swift
//  target
//
//  Created by Cecilia Domingo on 5/28/20.
//  Copyright © 2020 TopTier labs. All rights reserved.
//

import UIKit

extension UINavigationController {
  
  func setupNavigationBar() {
    setNavigationBarHidden(false, animated: true)
    navigationBar.tintColor = .black
    navigationBar.barTintColor = .white
    navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 13) ?? UIFont.systemFont(ofSize: 13)]
  }
}
