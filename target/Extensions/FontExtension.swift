//
//  FontExtension.swift
//  target
//
//  Created by Germán Stábile on 2/28/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import RSFontSizes

extension UIFont {
  
  class func bold(ofSize size: CGFloat) -> UIFont {
    return font(withName: "OpenSans-Bold", size: size)
  }
  
  class func extraBold(ofSize size: CGFloat) -> UIFont {
    return font(withName: "OpenSans-ExtraBold", size: size)
  }

  class func light(ofSize size: CGFloat) -> UIFont {
    return font(withName: "OpenSans-Regular", size: size)
  }

  class func regular(ofSize size: CGFloat) -> UIFont {
    return font(withName: "OpenSans-Regular", size: size)
  }
  
  class func semiBold(ofSize size: CGFloat) -> UIFont {
    return font(withName: "OpenSans-SemiBold", size: size)
  }
  
  private func withWeight(_ weight: UIFont.Weight) -> UIFont {
    var attributes = fontDescriptor.fontAttributes
    var traits = (attributes[.traits] as? [UIFontDescriptor.TraitKey: Any]) ?? [:]
    
    traits[.weight] = weight
    
    attributes[.name] = nil
    attributes[.traits] = traits
    attributes[.family] = familyName
    
    let descriptor = UIFontDescriptor(fontAttributes: attributes)
    
    return UIFont(descriptor: descriptor, size: pointSize)
  }
  
  static func font(withName name: String, size: CGFloat) -> UIFont {
    let size = Font.PointSize.proportional(to: (.screen6_5Inch,
                                                size)).value()
    let font = UIFont(name: name,
                      size: size)
    return font ?? UIFont.systemFont(ofSize: size)
  }
  
}
