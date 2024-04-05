//
//  YandexMobileMetrica.swift
//  Tracker
//
//  Created by artem on 02.04.2024.
//

import Foundation
import YandexMobileMetrica

final class YandexMobileMetrica {
    // MARK: - Identifier
    static let shared = YandexMobileMetrica()
    // MARK: - Public Methods
    func reportEvent(event: String, parameters: [String: String]) {
            YMMYandexMetrica.reportEvent(event, parameters: parameters, onFailure: { error in
                print("REPORT ERROR: %@", error.localizedDescription)
            })
        }
}

