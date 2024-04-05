//
//  HeaderEmojiCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.01.2024.
//

import UIKit

final class HeaderEmojiCell: UICollectionReusableView {
    // MARK: - Identifer
    static let identifier = "headerEmojiCell"
    //MARK: - UI
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.text = NSLocalizedString("Emoji", comment: "")
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
    //MARK: - Private Methods
    private func setupViews() {
        addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
}
