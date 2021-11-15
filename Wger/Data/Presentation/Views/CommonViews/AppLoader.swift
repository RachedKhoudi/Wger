//
//  AppLoader.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Foundation
import UIKit

// MARK: - App Loader

final class AppLoader: UIView {
    
    // MARK: - UI Components

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        view.isHidden = false
        return view
    }()
    
    // MARK: - init

    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        addSubview(backgroundView)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        backgroundView.anchor(self)
        activityIndicator.anchor(self)
    }
}
