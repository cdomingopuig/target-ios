//
//  AppNavigator.swift
//  target
//
//  Created by Mauricio Cousillas on 6/13/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

class AppNavigator: BaseNavigator {
  static let shared = AppNavigator()

  init() {
    let initialRoute: Route = SessionManager.validSession ?
      HomeRoutes.home : OnboardingRoutes.signIn
    super.init(with: initialRoute)
  }

  required init(with route: Route) {
    super.init(with: route)
  }
}
