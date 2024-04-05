//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 13.01.2024.
//
import UIKit

enum checkTypeHabitOrEvent {
    case create
    case edit
}

final class CreateNewCategoryViewController: UIViewController {
    //MARK: - Identifier
    static let identifier = Notification.Name(rawValue: "ChangeCategoryName")
    // MARK: - Public properties:
    var editNameCategory: String?
    // MARK: - Private properties:
    private let eventTypeHabit: checkTypeHabitOrEvent
    private var categoryName: String = ""
    private let categoryStore = TrackerCategoryStore.shared
    private var categoryTopTitle: String {
        switch eventTypeHabit {
        case .create:
            return NSLocalizedString("NewCategory", comment: "")
        case .edit:
            return NSLocalizedString("EditingCategory", comment: "")
        }
    }
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = categoryTopTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameTrackerTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypBlack
        textField.placeholder = NSLocalizedString("EnterNameOfCategory", comment: "")
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.layer.cornerRadius = 16
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(setTextValue), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(eventType: checkTypeHabitOrEvent) {
        self.eventTypeHabit = eventType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapGestureToHideKeyboard()
        setupView()
        setupConstraints()
        checkCorrectness()
        view.backgroundColor = .ypWhite
        if eventTypeHabit == .edit {
            nameTrackerTextField.text = editNameCategory
        }
    }
    //MARK: - Private Methods
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38))
        
        constraints.append(nameTrackerTextField.heightAnchor.constraint(equalToConstant: 75))
        constraints.append(nameTrackerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16))
        constraints.append(nameTrackerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16))
        constraints.append(nameTrackerTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38))
        
        constraints.append(doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        constraints.append(doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        constraints.append(doneButton.heightAnchor.constraint(equalToConstant: 60))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(nameTrackerTextField)
        view.addSubview(doneButton)
    }
    
    private func checkCorrectness() {
        guard let text = nameTrackerTextField.text else {
            return
        }
        doneButton.isEnabled = !text.isEmpty
        if doneButton.isEnabled {
            doneButton.backgroundColor = .ypBlack
            doneButton.tintColor = .ypWhite
        } else {
            doneButton.backgroundColor = .ypGray
            doneButton.tintColor = .ypWhite
        }
    }
    
    //MARK: - Objc Metods
    @objc private func doneButtonClicked() {
        if eventTypeHabit == .create {
            do {
                try categoryStore.createCategoryCoreData(with: categoryName)
            } catch {
                let alertController = UIAlertController(
                    title: NSLocalizedString("Error", comment: ""),
                    message: NSLocalizedString("ErrorCreatingCategory", comment: ""),
                    preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
            }
        } else if eventTypeHabit == .edit {
            guard let editingCategoryName = editNameCategory else { return }
            do {
                try categoryStore.updateCategory(categoryName: editingCategoryName, with: categoryName)
            } catch {
                //TODO: Alert
            }
        }
        NotificationCenter.default.post(name: CreateNewCategoryViewController.identifier, object: self)
        self.dismiss(animated: true)
    }
    
    @objc private func setTextValue() {
        checkCorrectness()
    }
}

// MARK: - UITextFieldDelegate
extension CreateNewCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryName = textField.text ?? ""
    }
}
