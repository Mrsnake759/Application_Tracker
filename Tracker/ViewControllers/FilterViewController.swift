//
//  FilterViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 29.01.2024.
//

import UIKit

final class FilterViewController: UIViewController {
    // MARK: - Delegate
    weak var delegate: FilterViewControllerDelegate?
    // MARK: - Public Properties
    var selectedFilter: Filters?
    // MARK: - Private Properties
    private let filters: [Filters] = Filters.allCases
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.text = NSLocalizedString("Filters", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .ypBackground
        tableView.layer.cornerRadius = 16
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: FilterTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupView()
        setupConstraints()
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38))
        constraints.append(titleLabel.heightAnchor.constraint(equalToConstant: 22))
        
        constraints.append(filterTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30))
        constraints.append(filterTableView.heightAnchor.constraint(equalToConstant: 300))
        constraints.append(filterTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16))
        constraints.append(filterTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(filterTableView)
    }
}
//MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        cell.setCheckMark(isHidden: false)
        let filter = filters[indexPath.row]
        delegate?.selectFilter(filter)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterTableViewCell else { return }
        cell.setCheckMark(isHidden: true)
    }
}
//MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.identifier) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        let name = filters[indexPath.row].name
        let status = name != selectedFilter?.name
        cell.configureCell(nameFilter: name, checkmarkStatus: status, isLastCell: indexPath.row == 3)
        return cell
    }
}
