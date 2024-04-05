//
//  FilterModel.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 29.01.2024.
//

import Foundation
enum Filters: String, CaseIterable {
    case allTrackers
    case todayTrackers
    case completedTrackers
    case noCompletedTrackers
    
    var name: String {
        switch self {
        case .allTrackers:
            return NSLocalizedString("AllTrackers", comment: "")
        case .todayTrackers:
            return NSLocalizedString("TrackersForToday", comment: "")
        case .completedTrackers:
            return NSLocalizedString("Completed", comment: "")
        case .noCompletedTrackers:
            return NSLocalizedString("NotCompleted", comment: "")
        }
    }
}
