//
//  UIViewExtension.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Foundation
import UIKit

// MARK: - UIView extension

extension UIView {
    
    func anchor(_ view: UIView, insets: NSDirectionalEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(view, insets))
    }
    func constraints(
        _ view: UIView,
        _ spacing: NSDirectionalEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor, constant: spacing.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: spacing.leading),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: spacing.trailing),
        ]
    }
}
