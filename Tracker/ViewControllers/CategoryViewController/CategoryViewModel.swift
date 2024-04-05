//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 28.01.2024.
//

import UIKit
//TODO: Закрыть ViewModel протоколом

final class CategoryViewModel: NSObject {
    //MARK: - Delegate
    weak var delegate: CategoryViewControllerDelegate?
    //MARK: - Public Properties
    var onChange: (() -> Void)?
    //MARK: - Private Properties
    private var selectedCategory: String = ""
    private let categoryStore = TrackerCategoryStore.shared
    private let trackerStore = TrackerStore.shared
    private let recordStore = TrackerRecordStore.shared
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            onChange?()
        }
    }
    func categoriesNumber() -> Int {
        categories.count
    }
    
    func didSelectCategory() {
        delegate?.selectedCategory = selectedCategory
        delegate?.didSelectCategory()
    }
    
    func setTextLabel(cell: UITableViewCell) {
        selectedCategory = cell.textLabel?.text ?? ""
    }
    
    func initSelectedCategory() {
        selectedCategory = delegate?.selectedCategory ?? ""
    }
    
    func checkTextSelectedCategory(cell: UITableViewCell) -> Bool {
        if selectedCategory == cell.textLabel?.text ?? "" {
            return true
        } else {
            return false
        }
    }
    
    func deleteCategory(_ title: String) {
        guard let trackers = categories.first(where: { $0.headerName == title })?.trackerArray else {
            return
        }
        do { 
            try trackers.forEach({ try trackerStore.deleteTracker($0) })
        } catch {
            //TODO: ALERT
        }
        do {
           try trackers.forEach { try recordStore.deleteRecordFromCoreData($0.id) }
        } catch {
            //TODO: ALERT
        }
        
        if let categoryToDelete = try? categoryStore.fetchTrackerCategoryCoreData(title: title) {
            do {  
                try categoryStore.deleteCategory(categoryToDelete)
            } catch {
                //TODO: ALERT
            }
        } else {
            return
        }
    }
    // MARK: - Initializers
    override init() {
        super.init()
        categoryStore.delegate = self
        trackerCategoryDidUpdate()
    }
}
//MARK: - TrackerCategoryDelegate
extension CategoryViewModel: TrackerCategoryDelegate {
    func trackerCategoryDidUpdate() {
        categories = categoryStore.categories
    }
}


