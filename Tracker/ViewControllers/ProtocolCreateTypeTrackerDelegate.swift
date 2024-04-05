//
//  ProtocolCreateTypeTrackerDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 19.01.2024.
//

import Foundation

protocol CreateTypeTrackerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, with category: String)
}
