//
//  AlertPresenterProtocol.swift
//  Tracker
//
//  Created by artem on 31.03.2024.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}
