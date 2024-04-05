//
//  AlertModel.swift
//  Tracker
//
//  Created by artem on 31.03.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let firstText: String
    let secondText: String
    let completion: (() -> Void)
}
