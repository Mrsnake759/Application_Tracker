//
//  FilterViewControllerDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 29.01.2024.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func selectFilter(_ filter: Filters)
}
