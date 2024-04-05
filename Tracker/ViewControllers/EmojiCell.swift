//
//  EmojiCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.01.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    // MARK: - Identifer
    static let identifier = "emojiCell"
    //MARK: - UI
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
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
        contentView.addSubview(titleLabel)
    }
    
    func configure(withEmoji emoji: String?) {
        titleLabel.text = emoji
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
             titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         ])
    }
}
