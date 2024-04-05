//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 13.01.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    //MARK: - Delegate
    var viewModelDelegate: CategoryViewControllerDelegate?
    //MARK: - Public Properties
    var viewModel: CategoryViewModel
    //MARK: - Private Properties
    private var alertPresenter: AlertPresenterProtocol?
    //MARK: - UI
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("Category", comment: "")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("AddCategory", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.tintColor = .ypWhite
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stubImageView: UIImageView = {
        let image = UIImage(named: "StubImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("StubLabelHabitsAndEvents", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategorySettingsTableViewCell.self, forCellReuseIdentifier: CategorySettingsTableViewCell.identifier)
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .ypGray
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        view.backgroundColor = .ypWhite
        viewModel.delegate = viewModelDelegate
        alertPresenter = AlertPresenter(delegate: self)
        bind()
        showOrHideEmptyLabels()
        
    }
    // MARK: - LifeCycle:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.initSelectedCategory()
    }
    //MARK: - Private Metods
    private func bind() {
        viewModel.onChange = { [weak self] in
            self?.showOrHideEmptyLabels()
            self?.categoryTableView.reloadData()
        }
    }
    private func showOrHideEmptyLabels() {
        if !viewModel.categories.isEmpty {
            stubLabel.isHidden = true
            stubImageView.isHidden = true
            categoryTableView.isHidden = false
        } else {
            categoryTableView.isHidden = true
            stubLabel.isHidden = false
            stubImageView.isHidden = false
        }
    }
    
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        //Текстовая картинка в центре главного экрана
        constraints.append(stubImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(stubImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor))
        constraints.append(stubImageView.heightAnchor.constraint(equalToConstant: 80))
        constraints.append(stubImageView.widthAnchor.constraint(equalToConstant: 80))
        
        //Текстовая заглушка в центре главного экрана
        constraints.append(stubLabel.centerXAnchor.constraint(equalTo: stubImageView.centerXAnchor))
        constraints.append(stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8))
        constraints.append(stubLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16))
        constraints.append(stubLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16))
        
        constraints.append(titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 38))
        
        constraints.append(categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16))
        constraints.append(categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16))
        constraints.append(categoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38))
        constraints.append(categoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor))
        
        constraints.append(addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20))
        constraints.append(addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20))
        constraints.append(addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        
        constraints.append(addCategoryButton.heightAnchor.constraint(equalToConstant: 60))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(stubImageView)
        view.addSubview(stubLabel)
        view.addSubview(categoryTableView)
    }
    
    private func showAlert(for category: String) {
        let alertModel = AlertModel(
            title: NSLocalizedString("CategoryNotNeeded", comment: ""),
            message: NSLocalizedString("TrackersWillAlsoDeleted", comment: ""),
            firstText: NSLocalizedString("Delete", comment: ""),
            secondText: NSLocalizedString("Undo", comment: "")) { [weak self] in
                guard let self = self else { return }
                viewModel.deleteCategory(category)
            }
        alertPresenter?.showAlert(model: alertModel)
    }
    
    //MARK: - Objc Metods
    @objc private func addCategoryButtonClicked() {
        let viewController = CreateNewCategoryViewController(eventType: .create)
        self.present(viewController, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoriesNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategorySettingsTableViewCell.identifier,
            for: indexPath)
                as? CategorySettingsTableViewCell
        else {
            assertionFailure("Не удалось выполнить приведение к UITableViewCell")
            return UITableViewCell()
        }
        cell.viewModel = viewModel
        cell.configureCell(indexPath: indexPath)
        return cell
    }
}
//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategorySettingsTableViewCell else {
            return
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        viewModel.setTextLabel(cell: cell)
        viewModel.didSelectCategory()
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            guard let cell = tableView.cellForRow(at: indexPath) as? CategorySettingsTableViewCell else {
                return UIMenu()
            }
            
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: "")) { [weak self] action in
                guard let self = self else { return }
                let editNameCategory = cell.textLabel?.text
                let viewController = CreateNewCategoryViewController(eventType: .edit)
                viewController.editNameCategory = editNameCategory
                self.present(viewController, animated: true)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), attributes: .destructive) { [weak self] action in
                guard let self = self else { return }
                let deleteCategory = cell.textLabel?.text
                guard let categoryToDelete = deleteCategory else { return }
                self.showAlert(for: categoryToDelete)
            }
            return UIMenu(children: [editAction, deleteAction])
        }
        return configuration
    }
}


