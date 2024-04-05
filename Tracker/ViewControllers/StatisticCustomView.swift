//
//  StatisticCustomView.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 30.01.2024.
//

import UIKit

final class StatisticCustomView: UIView {
    //MARK: - UI
    private lazy var innerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - Initializers
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        setupConstraints()
        clipsToBounds = true
        layer.cornerRadius = 16
        addGradientView()
    }
    //MARK: - Public Properties
    func reloadView(number: String, name: String) {
        nameLabel.text = name
        counterLabel.text = number
    }
    //MARK: - Private Properties
    private func setupView() {
        addSubview(innerView)
        innerView.addSubview(counterLabel)
        innerView.addSubview(nameLabel)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            innerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
            
            counterLabel.topAnchor.constraint(equalTo: innerView.topAnchor, constant: 11),
            counterLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 11),
            counterLabel.heightAnchor.constraint(equalToConstant: 41),
            
            nameLabel.topAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: 11),
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
    
    private func addGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.ypColorSelection1.cgColor, UIColor.ypColorSelection9.cgColor, UIColor.ypColorSelection3.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
