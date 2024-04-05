//
//  ProtocolCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by artem on 12.03.2024.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    var selectedCategory: String { get set }
    func didSelectCategory()
}
