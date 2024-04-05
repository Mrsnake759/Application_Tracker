//
//  ProtocolTrackerCreateViewControllerDelegate.swift
//  Tracker
//
//  Created by artem on 22.03.2024.
//

import UIKit

protocol TrackerCreateViewControllerDelegate: AnyObject {
    func passingTracker(_ tracker: Tracker, _ category: String)
}
