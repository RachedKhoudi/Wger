//
//  BaseViewController.swift
//  Wger
//
//  Created by Rached Khoudi on 13/11/2021.
//

import Foundation
import UIKit

typealias OnRetry = () -> Void

class BaseViewController: UIViewController {
    
    // MARK: - State

    var state: State = .initial {
        didSet {
            syncUI()
        }
    }
    
    // MARK: - UI Components

    private weak var loader: AppLoader?
    private weak var errorView: AppError?
    
    var isLoaderViewPresented: Bool {
        loader?.superview == view
    }
    
    var isErrorViewPresented: Bool {
        errorView?.superview == view
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - BaseViewController.State

extension BaseViewController {
    
    enum State {
        case initial
        case loading
        case error(error: Error, onRetry: OnRetry)
        case done
    }
}

// MARK: - BaseViewController extension

extension BaseViewController {
    
    func syncUI() {
        switch state {
        case .loading:
            hideErrorView()
            self.showLoader()
        case let .error(error, onRetry):
            hideLoader()
            showErrorView(error, onRetry)
        default:
            hideErrorView()
            hideLoader()
        }
    }
    
    func showErrorView(_ error: Error, _ onRetry: @escaping OnRetry) {
        var networkingError: NetworkingError = .unkown
        if let error = error as? NetworkingError {
            networkingError = error
        }
        if let errorView = errorView {
            errorView.message = ErrorLocalizables.fetchNetworkingMessage(from: networkingError)
            errorView.onRetry = onRetry
        } else {
            let appError = AppError(
                message: ErrorLocalizables.fetchNetworkingMessage(from: networkingError),
                onRetry: onRetry
            )
            view.addSubview(appError)
            appError.anchor(view)
            errorView = appError
        }
    }
    
    func hideErrorView() {
        errorView?.removeFromSuperview()
    }
    
    func showLoader() {
        guard loader == nil else { return }
        let appLoader = AppLoader()
        view.addSubview(appLoader)
        appLoader.anchor(view)
        loader = appLoader
    }
    
    func hideLoader() {
        loader?.removeFromSuperview()
    }
}
