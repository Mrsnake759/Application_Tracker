//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 30.01.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    // MARK: - Delegate:
    weak var delegate: UIViewController?
    // MARK: - Initializers
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    // MARK: - Public Methods
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(
            title: model.firstText,
            style: .destructive) { _ in
                model.completion()
            }
        let secondAction = UIAlertAction(
            title: model.secondText,
            style: .cancel)
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        delegate?.present(alert, animated: true)
    }
}
