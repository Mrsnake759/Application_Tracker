//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 13.01.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    //MARK: - Delegate
    weak var scheduleViewControllerDelegate: ScheduleViewControllerDelegate?
    weak var trackerCreateViewControllerDelegate: TrackerCreateViewControllerDelegate?
    //MARK: - Private Properties
    var selectWeekDays: [Weekday] = []
    var editTracker: Tracker?
    private let trackerStore = TrackerStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    private let categoryViewModel = CategoryViewModel()
    internal var selectedCategory: String = ""
    private var configure: Array<SettingOptions> = []
    private let emojis: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3,
        .ypColorSelection4, .ypColorSelection5, .ypColorSelection6,
        .ypColorSelection7, .ypColorSelection8, .ypColorSelection9,
        .ypColorSelection10, .ypColorSelection11, .ypColorSelection12,
        .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = editTracker == nil ? NSLocalizedString("NewHabit", comment: "") : NSLocalizedString("HabitEditing", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var restrictionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("38CharacterLimit", comment: "")
        label.font = .systemFont(ofSize: 17)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypBlack
        textField.placeholder = NSLocalizedString("EnterNameOfTracker", comment: "")
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var clearTextFieldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "clear_icon"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(clearTextFieldButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var categoryOrScheduleTableView: UITableView = {
        var tableView = UITableView(frame: .zero)
        tableView.register(SettingsHabitOrEventCell.self, forCellReuseIdentifier: SettingsHabitOrEventCell.cellIdentifer)
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var cancelButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Undo", comment: ""), for: .normal)
        button.backgroundColor = .ypWhite
        button.tintColor = .ypRed
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let title = editTracker == nil ? NSLocalizedString("Create", comment: "") : NSLocalizedString("Save", comment: "")
        var button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .ypGray
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var buttonStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(HeaderEmojiCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderEmojiCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(HeaderColorCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderColorCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isMultipleTouchEnabled = true
        scroll.isScrollEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.decelerationRate = .init(rawValue: 1)
        return scroll
    }()
    
    private lazy var completedDaysLabel: UILabel = {
        let dayCounter = recordStore.records?.filter({ $0.id == editTracker?.id }).count
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.text = "\(dayCounter?.days() ?? 0.days())"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        appendSettingsToArray()
        view.backgroundColor = .ypWhite
        setupView()
        setupConstraints()
        checkCorrectness()
        self.addTapGestureToHideKeyboard()
        counterHidden()
    }
    //MARK: - Private Methods
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        let top: CGFloat = editTracker != nil ? 116 : 38
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 730)
        
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38))
        constraints.append(titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 68))
        constraints.append(titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -66))
        constraints.append(titleLabel.heightAnchor.constraint(equalToConstant: 22))
        
        constraints.append(completedDaysLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 38))
        constraints.append(completedDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16))
        constraints.append(completedDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16))
        constraints.append(completedDaysLabel.heightAnchor.constraint(equalToConstant: 38))
        
        constraints.append(scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: top))
        constraints.append(scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -5))
        
        constraints.append(nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75))
        constraints.append(nameTrackerTextField.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16))
        constraints.append(nameTrackerTextField.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16))
        constraints.append(nameTrackerTextField.topAnchor.constraint(equalTo: scrollView.topAnchor))
        
        constraints.append(categoryOrScheduleTableView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16))
        constraints.append(categoryOrScheduleTableView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16))
        constraints.append(categoryOrScheduleTableView.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 24))
        constraints.append(categoryOrScheduleTableView.heightAnchor.constraint(equalToConstant: 150))
        
        constraints.append(emojiCollectionView.topAnchor.constraint(equalTo: categoryOrScheduleTableView.bottomAnchor, constant: 32))
        constraints.append(emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 19))
        constraints.append(emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -19))
        constraints.append(emojiCollectionView.heightAnchor.constraint(equalToConstant: 222))
        
        constraints.append(colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16))
        constraints.append(colorCollectionView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 18))
        constraints.append(colorCollectionView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -18))
        constraints.append(colorCollectionView.heightAnchor.constraint(equalToConstant: 222))
        
        constraints.append(buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        constraints.append(buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20))
        constraints.append(buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        constraints.append(cancelButton.heightAnchor.constraint(equalToConstant: 60))
        constraints.append(createButton.heightAnchor.constraint(equalToConstant: 60))
        
        constraints.append(restrictionLabel.topAnchor.constraint(equalTo: nameTrackerTextField.bottomAnchor, constant: 8))
        constraints.append(restrictionLabel.leftAnchor.constraint(equalTo: nameTrackerTextField.leftAnchor, constant: 28))
        constraints.append(restrictionLabel.rightAnchor.constraint(equalTo: nameTrackerTextField.rightAnchor, constant: -28))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        view.addSubview(buttonStackView)
        view.addSubview(completedDaysLabel)
        scrollView.addSubview(nameTrackerTextField)
        scrollView.addSubview(restrictionLabel)
        scrollView.addSubview(categoryOrScheduleTableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(createButton)
    }
    private func counterHidden() {
        if let editingTracker = editTracker {
            completedDaysLabel.isEnabled = false
            nameTrackerTextField.text = editingTracker.name
            selectWeekDays = editingTracker.schedule
            selectedEmoji = editingTracker.emoji
            selectedColor = editingTracker.color
            didSelectDays()
            didSelectCategory()
        } else {
            completedDaysLabel.isHidden = true
        }
    }
    private func appendSettingsToArray() {
        configure.append(
            SettingOptions(
                name: NSLocalizedString("Category", comment: ""),
                pickedSettings: nil
            ))
        configure.append(SettingOptions(
            name: NSLocalizedString("Schedule", comment: ""),
            pickedSettings: nil
        ))
    }
    
    private func checkCorrectness() {
        if selectWeekDays.isEmpty || selectedCategory.isEmpty || nameTrackerTextField.text?.isEmpty == true || selectedColor == nil || selectedEmoji == nil {
            createButton.isEnabled = false
            createButton.backgroundColor = .ypGray
        } else {
            createButton.isEnabled = true
            createButton.backgroundColor = .ypBlack
        }
    }
    
    private func getCategoryFromCoreData() {
        guard let text = nameTrackerTextField.text, !text.isEmpty else { return }
        guard let color = selectedColor, let emoji = selectedEmoji else { return }
        let tracker = Tracker(id: UUID(),
                              name: text,
                              color: color,
                              emoji: emoji,
                              schedule: self.selectWeekDays,
                              pinned: false)
        do {
            if let categoryCoreData = try categoryStore.fetchTrackerCategoryCoreData(title: selectedCategory) {
                try trackerStore.addCoreDataTracker(tracker, with: categoryCoreData)
            }
        } catch {
            ////TODO: Alert
        }
    }
    
    private func updateTrackerCoreData() {
        var categoryCoreData: TrackerCategoryCoreData?
        do {
            categoryCoreData = try categoryStore.fetchTrackerCategoryCoreData(title: selectedCategory)
        } catch {
            //TODO: Alert
        }
        guard let text = nameTrackerTextField.text, !text.isEmpty else { return }
        guard let color = selectedColor, let emoji = selectedEmoji else { return }
        guard
            let editTracker,
            let selectedColor,
            let categoryCoreData,
            let selectedEmoji  else { return }
        let updatedTracker = Tracker(id: editTracker.id, name: text, color: color, emoji: emoji, schedule: self.selectWeekDays, pinned: editTracker.pinned)
        do {
            try trackerStore.updateTracker(updatedTracker, with: categoryCoreData)
        } catch {
            //TODO: Alert
        }
    }
    //MARK: - Objc Methods
    @objc func cancelButtonClicked() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc private func clearTextFieldButtonClicked() {
        nameTrackerTextField.text = ""
        clearTextFieldButton.isHidden = true
    }
    
    @objc func createButtonClicked() {
        if editTracker == nil {
            getCategoryFromCoreData()
        } else {
            updateTrackerCoreData()
        }
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    @objc private func textFieldDidChange() {
        if let text = nameTrackerTextField.text, !text.isEmpty {
            clearTextFieldButton.isHidden = false
        } else {
            clearTextFieldButton.isHidden = true
        }
        if nameTrackerTextField.text!.count >= 38 {
            restrictionLabel.isHidden = false
        } else {
            restrictionLabel.isHidden = true
        }
        checkCorrectness()
    }
}
// MARK: - UITextFieldDelegate
extension NewHabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - UITableViewDataSource
extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsHabitOrEventCell.cellIdentifer, for: indexPath) as? SettingsHabitOrEventCell else {
            assertionFailure("Не удалось выполнить приведение к SettingsHabitOrEventCell")
            return UITableViewCell()
        }
        cell.textLabel?.text = configure[indexPath.row].name
        cell.detailTextLabel?.text = configure[indexPath.row].pickedSettings
        cell.backgroundColor = .ypBackground
        return cell
    }
}
// MARK: - UITableViewDelegate
extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let viewController = CategoryViewController(viewModel: categoryViewModel)
            viewController.viewModelDelegate = self
            self.present(viewController, animated: true)
        } else if indexPath.row == 1 {
            let viewController = ScheduleViewController()
            viewController.delegate = self
            
            self.present(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        checkCorrectness()
    }
}
// MARK: - ScheduleViewControllerDelegate
extension NewHabitViewController: ScheduleViewControllerDelegate {
    func didSelectDays() {
        let schedule = selectWeekDays.isEmpty ? "" : selectWeekDays.map { $0.shortDayName }.joined(separator: ", ")
        configure[1].pickedSettings = schedule
        categoryOrScheduleTableView.reloadData()
        checkCorrectness()
        dismiss(animated: true)
    }
}
extension NewHabitViewController: CategoryViewControllerDelegate {
    func didSelectCategory() {
        configure[0].pickedSettings = selectedCategory
        categoryOrScheduleTableView.reloadData()
        checkCorrectness()
        dismiss(animated: true)
    }
}
// MARK: - UICollectionViewDataSource
extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EmojiCell.identifier,
                for: indexPath) as? EmojiCell else {
                assertionFailure("Не удалось выполнить приведение к EmojiCell")
                return UICollectionViewCell()
            }
            cell.configure(withEmoji: emojis[indexPath.item])
            
            
            return cell
        } else if collectionView == colorCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ColorCell.identifier,
                for: indexPath) as? ColorCell else {
                assertionFailure("Не удалось выполнить приведение к ColorCell")
                return UICollectionViewCell()
            }
            cell.configure(backgroundColor: colors[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == emojiCollectionView {
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderEmojiCell.identifier,
                for: indexPath) as? HeaderEmojiCell else {
                assertionFailure("Не удалось выполнить приведение к EmojiHeader")
                return UICollectionReusableView()
            }
            return view
        } else if collectionView == colorCollectionView {
            guard let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderColorCell.identifier,
                for: indexPath) as? HeaderColorCell else {
                assertionFailure("Не удалось выполнить приведение к ColorHeader")
                return UICollectionReusableView()
            }
            return view
        }
        return UICollectionReusableView()
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 36) / 6
        let cellHeight = 52.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
    
}
// MARK: - UICollectionViewDelegate
extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            selectedEmoji = emojis[indexPath.item]
            cell?.layer.masksToBounds = true
            cell?.layer.cornerRadius = 16
            cell?.backgroundColor = .ypLightGray
            checkCorrectness()
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            selectedColor = colors[indexPath.item]
            cell?.layer.masksToBounds = true
            cell?.layer.cornerRadius = 9
            cell?.layer.borderWidth = 3
            cell?.setBorderColorCell()
            checkCorrectness()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.backgroundColor = .clear
            checkCorrectness()
        } else if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            cell?.layer.borderWidth = 0
            checkCorrectness()
        }
    }
}

