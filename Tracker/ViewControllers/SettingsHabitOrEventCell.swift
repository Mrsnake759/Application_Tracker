//
//  SettingsHabitOrEventCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 18.01.2024.
//

import UIKit

final class SettingsHabitOrEventCell: UITableViewCell {
    //MARK: - Identifer
    static let cellIdentifer = "cell"
    //MARK: - UI
    private lazy var chevronImage: UIImageView = {
        return UIImageView(image: UIImage(named: "Chevron"))
    }()
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = .ypGray
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    private func setupConstraints() {
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(chevronImage)
        chevronImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chevronImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chevronImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

