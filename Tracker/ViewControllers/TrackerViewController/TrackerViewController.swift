//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.12.2023.
//

import UIKit

final class TrackerViewController: UIViewController {
    // MARK: - Private Properties
    private let settingsConstraintsCell: CollectionSettings = CollectionSettings(cellsQuantity: 2, rightInset: 16, leftInset: 16, cellSpacing: 9)
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var visibleCategories: [TrackerCategory] = []
    private var dataManager = MocksTracker.mocksTrackers
    private let trackerStore = TrackerStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    private var filterStorage = FilterStorage()
    private var alertPresenter: AlertPresenterProtocol?
    private let yandexMetrica = YandexMobileMetrica.shared
    private var newCategoryVCObserver: NSObjectProtocol?
    private var isSearching: Bool = false
    //MARK: - UI
    private lazy var stubImageView: UIImageView = {
        let image = UIImage(named: "StubImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("WhatWillWeTrack", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundImage = .none
        searchBar.backgroundColor = .none
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.searchTextField.backgroundColor = .ypSearch
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clearButtonMode = .never
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.layer.backgroundColor = UIColor.ypPicker.cgColor
        picker.layer.cornerRadius = 8
        picker.layer.masksToBounds = true
        picker.tintColor = .ypBlue
        picker.calendar.firstWeekday = 2
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        picker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        collectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .ypWhite
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.layer.cornerRadius = 8
        indicatorView.layer.masksToBounds = true
        indicatorView.color = .ypBlack
        indicatorView.backgroundColor = .ypGray
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Filters", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .ypBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureToHideKeyboard()
        alertPresenter = AlertPresenter(delegate: self)
        view.backgroundColor = .ypWhite
        trackerStore.delegate = self
        updateTrackerCategories()
        updateMadeTrackers()
        reloadVisibleCategories()
        setupView()
        navBarItem()
        setupConstraints()
        newCategoryVCObserver = NotificationCenter.default.addObserver(
            forName: CreateNewCategoryViewController.identifier,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            updateTrackerCategories()
            reloadVisibleCategories()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        yandexMetrica.reportEvent(event: "Open TrackersViewController", parameters: ["event": "open", "screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        yandexMetrica.reportEvent(event: "Closed TrackersViewController", parameters: ["event": "close", "screen": "Main"])
    }
    // MARK: - Private Methods
    private func showPlaceholder() {
        settingsEmptyLabels()
        if !visibleCategories.isEmpty {
            stubLabel.isHidden = true
            stubImageView.isHidden = true
            trackersCollectionView.isHidden = false
        } else {
            trackersCollectionView.isHidden = true
            stubLabel.isHidden = false
            stubImageView.isHidden = false
        }
    }
    
    private func settingsEmptyLabels() {
        if visibleCategories.isEmpty && (filterStorage.filter == .noCompletedTrackers || filterStorage.filter == .completedTrackers) || isSearching {
            stubImageView.image = UIImage(named: "noInfoImage")
            stubLabel.text = NSLocalizedString("NothingFound", comment: "")
        } else {
            stubImageView.image = UIImage(named: "StubImage")
            stubLabel.text = NSLocalizedString("WhatWillWeTrack", comment: "")
        }
    }
    
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(trackersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34))
        constraints.append(trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        constraints.append(stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        
        constraints.append(stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor))
        constraints.append(stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8))
        
        constraints.append(searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8))
        constraints.append(searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8))
        constraints.append(searchBar.heightAnchor.constraint(equalToConstant: 36))
        
        constraints.append(activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(activityIndicator.heightAnchor.constraint(equalToConstant: 51))
        constraints.append(activityIndicator.widthAnchor.constraint(equalToConstant: 51))
        
        constraints.append(filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130))
        constraints.append(filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16))
        constraints.append(filtersButton.heightAnchor.constraint(equalToConstant: 50))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(trackersCollectionView)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(searchBar)
        view.addSubview(filtersButton)
        trackersCollectionView.addSubview(activityIndicator)
    }
    
    private func navBarItem() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = NSLocalizedString("Trackers", comment: "")
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        
        let leftButton = UIBarButtonItem(
            image: UIImage(named: "PlusTask"),
            style: .plain,
            target: self,
            action: #selector(Self.didTapButton))
        leftButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func updateMadeTrackers() {
        if let records = recordStore.records {
            self.completedTrackers = records
        } else {
            self.completedTrackers = []
        }
    }
    
    private func updateTrackerCategories() {
        categories = categoryStore.categories
    }
    
    private func pinnedTrackerCategories() {
        let pinnedTrackers = categories.flatMap { category in
            category.trackerArray.filter { $0.pinned }
        }
        let pinnedCategory = TrackerCategory(headerName: NSLocalizedString("Pinned", comment: ""), trackerArray: pinnedTrackers)
        let trackerCategories: [TrackerCategory] = categories.compactMap { category in
            let trackers = category.trackerArray.filter { !$0.pinned }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(
                headerName: category.headerName,
                trackerArray: trackers)
        }
        if pinnedTrackers.isEmpty {
            categories = trackerCategories
        } else {
            categories = [pinnedCategory] + trackerCategories
        }
    }
    
    private func reloadVisibleCategories() {
        activityIndicator.startAnimating()
        let filterWeekday = Calendar.current.component(.weekday, from: datePicker.date)
        let filterText = (searchBar.text ?? "").lowercased()
        pinnedTrackerCategories()
        let filteredCategories: [TrackerCategory] = categories.compactMap { category in
            let trackers = category.trackerArray.filter { tracker in
                let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { Weekday in
                    Weekday.calendarDayNumber == filterWeekday
                } == true
                return textCondition && dateCondition
            }
            if trackers.isEmpty {
                return nil
            }
            return TrackerCategory(headerName: category.headerName, trackerArray: trackers)
        }
        if filterStorage.filter == .completedTrackers {
            let completedCategories: [TrackerCategory] = filteredCategories.compactMap { category in
                let filteredTrackers = category.trackerArray.filter { tracker in
                    let object = completedTrackers.contains { record in
                        return record.id == tracker.id && record.date.presentDay(datePicker.date)
                    }
                    return object
                }
                if !filteredTrackers.isEmpty {
                    return TrackerCategory(headerName: category.headerName, trackerArray: filteredTrackers)
                } else {
                    return nil
                }
            }
            visibleCategories = completedCategories
        } else if filterStorage.filter == .noCompletedTrackers {
            let noCompletedCategories: [TrackerCategory] = filteredCategories.compactMap { category in
                let filteredTrackers = category.trackerArray.filter { tracker in
                    let object = !completedTrackers.contains { record in
                        return record.id == tracker.id && record.date.presentDay(datePicker.date)
                    }
                    return object
                }
                if !filteredTrackers.isEmpty {
                    return TrackerCategory(headerName: category.headerName, trackerArray: filteredTrackers)
                } else {
                    return nil
                }
            }
            visibleCategories = noCompletedCategories
        } else {
            visibleCategories = filteredCategories
        }
        settingsScroll(cellCount: visibleCategories.flatMap({ $0.trackerArray }).count)
        settingsEmptyLabels()
        trackersCollectionView.reloadData()
        activityIndicator.stopAnimating()
        showPlaceholder()
    }
    
    private func showDeleteAlert(for tracker: Tracker) {
        let alertModel = AlertModel(
            title: NSLocalizedString("DeleteTheTracker", comment: ""),
            message: nil, firstText: NSLocalizedString("Delete", comment: ""),
            secondText: NSLocalizedString("Undo", comment: "")) { [weak self] in
                guard let self = self else { return }
                yandexMetrica.reportEvent(event: "Delete Tracker", parameters: ["event": "click", "screen": "Main", "item": "delete"])
                self.activityIndicator.startAnimating()
                do {
                    try self.trackerStore.deleteTracker(tracker) }
                catch {
                    //TODO: Alert
                }
                do { 
                    try self.recordStore.deleteRecordFromCoreData(tracker.id)
                } catch {
                    //TODO: Alert
                }
                self.activityIndicator.stopAnimating()
            }
        alertPresenter?.showAlert(model: alertModel)
    }
    
    private func pinnedTrackers(_ tracker: Tracker) {
        do { 
            try trackerStore.pinnedTrackerCoreData(tracker)
        } catch {
            //TODO: Alert
        }
    }
    private func conditionsFiltersButton(_ category: [TrackerCategory]) {
        filtersButton.isHidden = category.isEmpty && (filterStorage.filter == .allTrackers || filterStorage.filter == .todayTrackers)
    }
    private func settingsScroll(cellCount: Int) {
        let cellHeight: CGFloat = 148
        let headerHeight: CGFloat = 23
        let buttonHeight: CGFloat = 50
        let contentHeight = cellHeight * CGFloat(cellCount) + headerHeight * CGFloat(cellCount)
        let availableSpace = trackersCollectionView.frame.height
        let difference = availableSpace - contentHeight
        if difference <= CGFloat(10) {
            trackersCollectionView.contentInset.bottom = buttonHeight
            trackersCollectionView.alwaysBounceVertical = true
        } else {
            trackersCollectionView.contentInset.bottom = 0
            trackersCollectionView.alwaysBounceVertical = false
        }
    }
    // MARK: - Objc Methods:
    @objc private func didTapButton() {
        let viewController = CreateTypeTrackerViewController()
        yandexMetrica.reportEvent(event: "Add tracker button tapped on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "add_track"])
        present(viewController, animated: true)
    }
    
    @objc private func datePickerValueChanged() {
        if filterStorage.filter == .todayTrackers {
            filterStorage.filter = .allTrackers
        }
        reloadVisibleCategories()
    }
    
    @objc private func filtersButtonTapped() {
        yandexMetrica.reportEvent(event: "Did press the filters button on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "filter"])
        let viewController = FilterViewController()
        viewController.delegate = self
        viewController.selectedFilter = filterStorage.filter
        present(viewController, animated: true)
    }
    
}
// MARK: - UITextSearchBarDelegate:
extension TrackerViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.searchTextField.text else { return }
        isSearching = text.isEmpty ? false : true
        if text.isEmpty {
            searchBar.showsCancelButton = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
        } else {
            isSearching = true
        }
        reloadVisibleCategories()
        yandexMetrica.reportEvent(event: "Attempted searching for trackers on TrackersViewController", parameters: ["event": "search", "screen": "Main"])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = nil
        searchBar.showsCancelButton = false
        reloadVisibleCategories()
    }
}
// MARK: - UICollectionViewDelegate:
extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configure = UIContextMenuConfiguration(identifier: indexPath as NSCopying, actionProvider:  { actions in
            let tracker = self.visibleCategories[indexPath.section].trackerArray[indexPath.row]
            let pin = tracker.pinned ? NSLocalizedString("Unpin", comment: "") : NSLocalizedString("Pin", comment: "")
            let pinAction = UIAction(title: pin, handler: { [weak self] _ in
                guard let self else { return }
                self.pinnedTrackers(tracker)
            })
            
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: ""), handler: { [weak self] _ in
                guard let self else { return }
                if let categoryName = categoryStore.categories.first(where: { $0.trackerArray.contains { $0.name == tracker.name } })?.headerName {
                    yandexMetrica.reportEvent(event: "Attempted searching for trackers on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "edit"])
                    let viewController = NewHabitViewController()
                    viewController.editTracker = tracker
                    viewController.selectedCategory = categoryName
                    self.present(viewController, animated: true)
                }
            })
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), attributes: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                self.showDeleteAlert(for: tracker)
                
            })
            let contextMenu = UIMenu(children: [pinAction, editAction, deleteAction])
            return contextMenu
        })
        return configure
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else { return nil}
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell else {
            return nil
        }
        let previewView = cell.preview
        let targetedPreview = UITargetedPreview(view: previewView)
        
        return targetedPreview
    }
}


// MARK: - UICollectionViewDelegateFlowLayout:
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.size.width - settingsConstraintsCell.paddingWidth
        let cellWidth = availableWidth / CGFloat(settingsConstraintsCell.cellsQuantity)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        conditionsFiltersButton(visibleCategories)
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: settingsConstraintsCell.leftInset, bottom: 11, right: settingsConstraintsCell.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let header = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let headerSize = header.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
        return headerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        settingsConstraintsCell.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UICollectionViewDataSource:
extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell()}
        cell.delegate = self
        let tracker = visibleCategories[indexPath.section].trackerArray[indexPath.row]
        let isCompleted = completedTrackers.contains { record in
            record.id == tracker.id && record.date.presentDay(datePicker.date) }
        let isEnabled = datePicker.date.beforeDay(Date()) || Date().presentDay(datePicker.date)
        let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
        let isPinned = tracker.pinned
        cell.cellSettings(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            completedDays: completedDays,
            isEnabled: isEnabled,
            isCompleted: isCompleted,
            isPinned: isPinned
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCollectionViewHeader.identifier, for: indexPath) as? TrackerCollectionViewHeader else { return UICollectionViewCell() }
        cell.titleLabel.font = .boldSystemFont(ofSize: 19)
        cell.titleLabel.text = visibleCategories[indexPath.section].headerName
        return cell
    }
}
// MARK: - FiltersViewControllerDelegate
extension TrackerViewController: FilterViewControllerDelegate {
    func selectFilter(_ filter: Filters) {
        filterStorage.filter = filter
        switch filter {
        case .allTrackers:
            reloadVisibleCategories()
        case .todayTrackers:
            datePicker.date = Date()
            reloadVisibleCategories()
        case .completedTrackers:
            reloadVisibleCategories()
        case .noCompletedTrackers:
            reloadVisibleCategories()
        }
    }
}
// MARK: - TrackerCellDelegate:
extension TrackerViewController: TrackerCellDelegate {
    func trackerCompleted(for id: UUID) {
        yandexMetrica.reportEvent(event: "Get tracker completed from Core Data", parameters: ["event": "click", "screen": "Main"])
        if let index = completedTrackers.firstIndex(where: { $0.id == id && $0.date.presentDay(datePicker.date) }) {
            let recordToDelete = completedTrackers[index]
            completedTrackers.remove(at: index)
            try? recordStore.removeRecordCoreData(recordToDelete.id, with: recordToDelete.date)
        } else { completedTrackers.append(TrackerRecord(id: id, date: datePicker.date))
            try? trackerStore.trackerUpdate(TrackerRecord(id: id, date: datePicker.date))
        }
    }
}
// MARK: - TrackerStoreDelegate:
extension TrackerViewController: TrackerStoreDelegate {
    func trackerStoreDidUpdate() {
        updateTrackerCategories()
        updateMadeTrackers()
        reloadVisibleCategories()
    }
}
