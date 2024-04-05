//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by artem on 12.03.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func trackerCompleted(for id: UUID)
}
