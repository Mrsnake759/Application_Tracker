//
//  Extension Date.swift
//  Tracker
//
//  Created by artem on 13.03.2024.
//

import Foundation

extension Date {
    func presentDay(_ date: Date) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
    
    func beforeDay(_ date: Date) -> Bool {
        Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedAscending
    }
}
