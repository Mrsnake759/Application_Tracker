//
//  Tracker.swift
//  Tracker
//
//  Created by artem on 12.03.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let pinned: Bool
}
