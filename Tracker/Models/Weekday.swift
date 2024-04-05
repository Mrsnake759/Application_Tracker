//
//  Weekday.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 14.01.2024.
//

import Foundation

enum Weekday: String, CaseIterable, Codable {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
    var calendarDayNumber: Int {
        switch self {
        case .Monday:
            return 2
        case .Tuesday:
            return 3
        case .Wednesday:
            return 4
        case .Thursday:
            return 5
        case .Friday:
            return 6
        case .Saturday:
            return 7
        case .Sunday:
            return 1
        }
    }
    
    var shortDayName: String {
        switch self {
        case .Monday:
            return NSLocalizedString("Mon", comment: "")
        case .Tuesday:
            return NSLocalizedString("Tue", comment: "")
        case .Wednesday:
            return NSLocalizedString("Wed", comment: "")
        case .Thursday:
            return NSLocalizedString("Thu", comment: "")
        case . Friday:
            return NSLocalizedString("Fri", comment: "")
        case .Saturday:
            return NSLocalizedString("Sat", comment: "")
        case .Sunday:
            return NSLocalizedString("Sun", comment: "")
        }
    }
    
    var localizedDay: String {
        switch self {
        case .Monday:
            return NSLocalizedString("Monday", comment: "")
        case .Tuesday:
            return NSLocalizedString("Tuesday", comment: "")
        case .Wednesday:
            return NSLocalizedString("Wednesday", comment: "")
        case .Thursday:
            return NSLocalizedString("Thursday", comment: "")
        case .Friday:
            return NSLocalizedString("Friday", comment: "")
        case .Saturday:
            return NSLocalizedString("Saturday", comment: "")
        case .Sunday:
            return NSLocalizedString("Sunday", comment: "")
        }
    }
}
