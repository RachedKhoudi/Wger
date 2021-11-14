//
//  UIWindowExtension.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import UIKit

extension UIWindow {
    
    class func makeWindow(with windowScene: UIWindowScene, viewController: UIViewController) -> UIWindow {
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UINavigationController(rootViewController: viewController)
        return window
    }
}
