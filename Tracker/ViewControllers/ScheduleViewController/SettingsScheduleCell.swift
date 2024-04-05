//
//  SettingsTableViewCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 14.01.2024.
//

import UIKit

final class SettingsScheduleCell: UITableViewCell {
    // MARK: - Identider
    static let cellIdentifier = "TableViewCell"
    // MARK: - Delegate
    weak var delegate: ScheduleCellDelegate?
    // MARK: - Private Properties
    private var weekDay: Weekday?
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self, action: #selector(switchButtonTapped(_:)), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods:
    func configureCell(with weekDay: Weekday, isLastCell: Bool, isSelected: Bool) {
        self.weekDay = weekDay
        titleLabel.text = weekDay.localizedDay
        separatorView.isHidden = isLastCell
        switchButton.isOn = isSelected
    }
    // MARK: - Private Methods:
    private func setupViews() {
        contentView.backgroundColor = .ypBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchButton)
        contentView.addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            
        ])
    }
    // MARK: - Objc Methods
    @objc private func switchButtonTapped(_ sender: UISwitch) {
        guard let weekDay = weekDay else { return }
        delegate?.switchButtonClicked(to: sender.isOn, of: weekDay)
    }
}



