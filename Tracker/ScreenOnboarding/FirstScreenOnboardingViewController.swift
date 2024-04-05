//
//  FirstScreenOnboardingViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 27.01.2024.
//

import UIKit

final class FirstScreenOnboardingViewController: UIViewController {
    //MARK: - UI
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "FirstImageOnboarding")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = NSLocalizedString("TrackOnlyWant", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    // MARK: - Private Methods:
    private func setupConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        
        constraints.append(textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16))
        constraints.append(textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16))
        constraints.append(textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(textLabel)
    }
}
