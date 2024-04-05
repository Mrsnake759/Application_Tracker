//
//  Extension Int.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 18.01.2024.
//

import Foundation

extension Int {
    func days() -> String {
        var dayString: String!
        if "1".contains("\(self % 10)") { dayString = "день"}
        if "234".contains("\(self % 10)") { dayString = "дня" }
        if "567890".contains("\(self % 10)") { dayString = "дней"}
        if 11...14 ~= self % 100 { dayString = "дней"}
        return "\(self) " + dayString
    }
}
