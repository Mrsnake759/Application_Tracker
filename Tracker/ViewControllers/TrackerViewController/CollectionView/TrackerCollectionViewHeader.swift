//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 17.01.2024.
//

import UIKit

final class TrackerCollectionViewHeader: UICollectionReusableView {
    //MARK: - Identifer:
    static let identifier = "header"
    // MARK: - UI:
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods:
    private func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
}
