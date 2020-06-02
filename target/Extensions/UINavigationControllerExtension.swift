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
    navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.black,
      .font: UIFont.semiBold(ofSize: 13)
    ]
  }
}
