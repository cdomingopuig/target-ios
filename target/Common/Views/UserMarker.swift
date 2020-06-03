//
//  UserMarker.swift
//  target
//
//  Created by Cecilia Domingo on 5/29/20.
//  Copyright © 2020 TopTier labs. All rights reserved.
//

import UIKit

let UserMarkerHeight: Double = 73.9
let UserMarkerWidth: Double = 51
let UserMarkerAnchor = (x: 0.5, y: 0.6549)

class UserMarker: UIView {
  var shouldSetupConstraints = true
  
  var pin: UIImageView!
  var circle:  UIImageView!
    
  override init(frame: CGRect) {
    super.init(frame: frame)
    let pinHeight = UserMarkerHeight - UserMarkerWidth/2
    let pinWidth = 41.74
    let pinMarginLeft = (UserMarkerWidth - pinWidth)/2
    let circleY = UserMarkerHeight - UserMarkerWidth
    
    circle = UIImageView(frame: CGRect(x: 0, y: circleY, width: UserMarkerWidth, height: UserMarkerWidth))
    circle.image = UIImage(named: "user-radius")
    self.addSubview(circle)
    
    pin = UIImageView(frame: CGRect(x: pinMarginLeft, y: 0, width: pinWidth, height: pinHeight))
    pin.image = UIImage(named: "user-marker")
    self.addSubview(pin)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
    
  override func updateConstraints() {
    if(shouldSetupConstraints) {
      shouldSetupConstraints = false
    }
    super.updateConstraints()
  }
}
