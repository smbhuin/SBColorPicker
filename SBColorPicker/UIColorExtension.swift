//
//  UIColorExtension.swift
//  SBColorPicker
//
//  Created by Soumen Bhuin on 20/11/23.
//  Copyright © 2023 smbhuin. All rights reserved.
//

import UIKit

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIColor {
    convenience init(hexString: String) {
        var rgbValue: UInt64 = 0
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1 // bypass '#' character
        }
        scanner.scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
                  green: CGFloat((rgbValue & 0xFF00) >> 8)/255.0,
                  blue: CGFloat(rgbValue & 0xFF)/255.0, alpha: 1.0)
    }

    var hexString: String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        let hexString = String.init(format: "#%02lX%02lX%02lX",
                                    lroundf(Float(red * 255)),
                                    lroundf(Float(green * 255)),
                                    lroundf(Float(blue * 255)))
        return hexString
    }

    func with(brightness: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, alpha: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

}
