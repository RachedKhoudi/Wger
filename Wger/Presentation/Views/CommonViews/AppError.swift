//
//  AppError.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Foundation
import UIKit

// MARK: - App Error

final class AppError: UIView {
    
    var message: String? {
        didSet {
            label.text = message
        }
    }
    
    var onRetry: OnRetry?
    
    // MARK: - UI Components

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [label, button])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private lazy var label: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.setTitleColor(.white, for: .normal)
        view.setTitle("retry".localized, for: .normal)
        view.heightAnchor.constraint(equalToConstant: ViewMetrics.buttonHeight).isActive = true
        return view
    }()
    
    // MARK: - init

    init(message: String = "", onRetry: OnRetry? = nil) {
        super.init(frame: .zero)
        commonInit(message: message, onRetry: onRetry)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(message: "", onRetry: nil)
    }
    
    private func commonInit(message: String, onRetry: OnRetry?) {
        backgroundColor = .white
        addSubview(stackView)
        setupConstraints()
        self.message = message
        self.onRetry = onRetry
        button.addTarget(self, action: #selector(handleRetryTouchUpInside), for: .touchUpInside)
    }
    
    // MARK: - Action

    @objc func handleRetryTouchUpInside() {
        self.removeFromSuperview()
        guard let retryAction = onRetry else { return }
        retryAction()
    }
}

// MARK: - App Error private extension

private extension AppError {
    
    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: ViewMetrics.padding
                ),
                stackView.trailingAnchor.constraint(
                    equalTo: trailingAnchor,
                    constant: -ViewMetrics.padding
                ),
                stackView.bottomAnchor.constraint(
                    greaterThanOrEqualTo: layoutMarginsGuide.bottomAnchor,
                    constant: -ViewMetrics.minVerticalPadding
                ),
                stackView.topAnchor.constraint(
                    greaterThanOrEqualTo: layoutMarginsGuide.topAnchor,
                    constant: ViewMetrics.minVerticalPadding
                ),
                NSLayoutConstraint(
                    item: stackView,
                    attribute: .centerY,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .centerY,
                    multiplier: 1,
                    constant: 0
                )
            ]
        )
    }
}

// MARK: - AppError.ViewMetrics

private extension AppError {
    
    struct ViewMetrics {
        static let padding: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let minVerticalPadding: CGFloat = 60
    }
}
