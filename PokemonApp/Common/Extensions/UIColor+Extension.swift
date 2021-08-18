//
//  UIColor+Extension.swift
//  PokemonApp
//

import UIKit

extension UIColor {
    
    enum Theme {
        /// Grey
        static let primaryColor = UIColor(0xF5F5F6)
        /// White
        static let backgroundColor = UIColor.white
    }
    
    enum Text {
        /// Black
        static let primaryColor = UIColor.black
        /// White
        static let secondaryColor = UIColor.white
    }
}

// MARK: - Helpers
extension UIColor {
    
   convenience init(red: Int, green: Int, blue: Int) {
       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(_ hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}
