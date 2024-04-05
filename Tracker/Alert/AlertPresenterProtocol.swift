//
//  AlertPresenterProtocol.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 30.01.2024.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}
