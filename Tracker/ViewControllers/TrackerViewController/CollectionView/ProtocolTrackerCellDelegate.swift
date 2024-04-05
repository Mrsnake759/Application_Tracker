//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 19.01.2024.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func trackerCompleted(for id: UUID)
}
