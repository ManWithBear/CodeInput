//
//  UIFont+Width.swift
//  CodeInput
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit.UIFont

extension UIFont {
    var maxWidth: CGFloat {
        return ("W" as NSString).size(attributes: [NSFontAttributeName: self]).width
    }
}
