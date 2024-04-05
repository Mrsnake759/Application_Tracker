//
//  AlertModel.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 30.01.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String?
    let firstText: String
    let secondText: String
    let completion: (() -> Void)
}
