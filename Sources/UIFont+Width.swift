//
//  UIFont+Width.swift
//  CodeInput
//
//  Created by Denis Bogomolov on 04/03/2017.
//

import UIKit.UIFont

extension UIFont {
    var mWidth: CGFloat {
        return ("M" as NSString).size(withAttributes: [.font: self]).width
    }
}
