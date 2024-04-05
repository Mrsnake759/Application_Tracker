//
//  ProtocolCreateTypeTrackerDelegate.swift
//  Tracker
//
//  Created by artem on 22.03.2024.
//

import Foundation

protocol CreateTypeTrackerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, with category: String)
}
