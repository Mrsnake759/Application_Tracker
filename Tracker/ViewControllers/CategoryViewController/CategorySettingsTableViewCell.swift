//
//  CategorySettingsTableViewCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 28.01.2024.
//

import UIKit

final class CategorySettingsTableViewCell: UITableViewCell {
    // MARK: - Public Properties
    static let identifier = "Cell"
    var viewModel: CategoryViewModel?
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods
    func configureCell(indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        selectionStyle = .none
        layer.masksToBounds = true
        textLabel?.text = viewModel.categories[indexPath.row].headerName
        if viewModel.categoriesNumber() == 1 {
            layer.cornerRadius = 16
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
        } else if indexPath.row == viewModel.categoriesNumber() - 1 {
            layer.cornerRadius = 16
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1000)
        } else {
            layer.cornerRadius = 0
            separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        
        if viewModel.checkTextSelectedCategory(cell: self) == true {
            accessoryView = UIImageView(image: UIImage(named: "DoneCollectionButton"))
        } else {
            accessoryView = .none
        }
    }
    // MARK: - Private Methods
    private func setupView() {
        detailTextLabel?.textColor = .ypGray
        backgroundColor = .ypBackground
        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
}
