//
//  FilterTableViewCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 29.01.2024.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier = "TableViewCell"
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var checkMark: UIImageView = {
        let image = UIImage(systemName: "checkmark")
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        backgroundColor = .ypBackground
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods:
    func configureCell(nameFilter: String, checkmarkStatus: Bool, isLastCell: Bool) {
        titleLabel.text = nameFilter
        checkMark.isHidden = checkmarkStatus
        separatorView.isHidden = isLastCell
    }
    
    func setCheckMark(isHidden: Bool) {
        checkMark.isHidden = isHidden
    }
    // MARK: - Private Methods:
    private func setupViews() {
        contentView.backgroundColor = .ypBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(separatorView)
        contentView.addSubview(checkMark)
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
            
            checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkMark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkMark.heightAnchor.constraint(equalToConstant: 24),
            checkMark.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
}
