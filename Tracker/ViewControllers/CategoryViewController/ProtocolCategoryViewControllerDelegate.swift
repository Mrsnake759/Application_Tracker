//
//  ProtocolCategoryViewControllerDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 25.01.2024.
//

import Foundation

protocol CategoryViewControllerDelegate: AnyObject {
    var selectedCategory: String { get set }
    func didSelectCategory()
}
