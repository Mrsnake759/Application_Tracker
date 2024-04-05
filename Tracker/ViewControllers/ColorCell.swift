//
//  ColorCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.01.2024.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    // MARK: - Identifer
    static let identifier = "colorCell"
    //MARK: - UI
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 9
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Public Methods
    func setBorderColorCell() {
        layer.borderColor = titleLabel.backgroundColor?.withAlphaComponent(0.3).cgColor
    }
    
    func configure(backgroundColor: UIColor?) {
        titleLabel.backgroundColor = backgroundColor
    }
    //MARK: - Private Methods
    private func setupViews() {
        contentView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
