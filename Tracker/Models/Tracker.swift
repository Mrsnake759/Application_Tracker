//
//  Tracker.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 25.12.2023.
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
