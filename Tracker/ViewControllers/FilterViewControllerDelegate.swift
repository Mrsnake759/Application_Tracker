//
//  FilterViewControllerDelegate.swift
//  Tracker
//
//  Created by artem on 31.03.2024.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func selectFilter(_ filter: Filters)
}
