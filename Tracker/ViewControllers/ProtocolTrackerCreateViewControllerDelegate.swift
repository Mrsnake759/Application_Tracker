//
//  ProtocolTrackerCreateViewControllerDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 19.01.2024.
//

import UIKit

protocol TrackerCreateViewControllerDelegate: AnyObject {
    func passingTracker(_ tracker: Tracker, _ category: String)
}
