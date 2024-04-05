//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 13.01.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    //MARK: - Delegate
    weak var delegate: ScheduleViewControllerDelegate?
    //MARK: - Private Properties
    private var selectWeekDays: [Weekday] = []
    //MARK: - UI
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("Schedule", comment: "")
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
    
    private var categoryOrScheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SettingsScheduleCell.self, forCellReuseIdentifier: SettingsScheduleCell.cellIdentifier)
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = 16
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    //MARK: - Lyfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupView()
        setupConstraints()
        categoryOrScheduleTableView.delegate = self
        categoryOrScheduleTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectWeekDays = delegate?.selectWeekDays ?? []
    }
    //MARK: - Private Methods
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(categoryOrScheduleTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30))
        constraints.append(categoryOrScheduleTableView.heightAnchor.constraint(equalToConstant: 525))
        constraints.append(categoryOrScheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16))
        constraints.append(categoryOrScheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16))
        
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38))
        constraints.append(titleLabel.heightAnchor.constraint(equalToConstant: 22))
        
        constraints.append(doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        constraints.append(doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20))
        constraints.append(doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(doneButton.heightAnchor.constraint(equalToConstant: 60))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(categoryOrScheduleTableView)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
    }
    //MARK: - Objc Methods
    @objc private func doneButtonClicked() {
        delegate?.selectWeekDays = selectWeekDays
        delegate?.didSelectDays()
        self.dismiss(animated: true)
    }
}
// MARK: - ScheduleCellDelegate
extension ScheduleViewController: ScheduleCellDelegate {
    func switchButtonClicked(to isSelected: Bool, of weekDay: Weekday) {
        if isSelected {
            selectWeekDays.append(weekDay)
        } else {
            selectWeekDays.removeAll { $0 == weekDay }
        }
    }
}
//MARK: - UITableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsScheduleCell.cellIdentifier, for: indexPath) as? SettingsScheduleCell else {
            fatalError("Не удалось найти ячейку SettingsScheduleCell")
        }
        cell.delegate = self
        cell.selectionStyle = .none
        let weekDay = Weekday.allCases[indexPath.row]
        cell.configureCell(
            with: weekDay,
            isLastCell: indexPath.row == 6,
            isSelected: selectWeekDays.contains(weekDay)
        )
        return cell
    }
}
