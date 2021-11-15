//
//  UIKitExtension.swift
//  Wger
//
//  Created by Rached Khoudi on 15/11/2021.
//

import Foundation

extension String {
    var localized: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
}
