//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 22.12.2023.
//

import Foundation
import UIKit

final class StatisticViewController: UIViewController {
    // MARK: - Private properties:
    private var completedTrackers: Int?
    private(set) var records: [TrackerRecord] = []
    private let recordStore = TrackerRecordStore.shared
    //MARK: - UI
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("NoAnalyze", comment: "")
        label.textColor = .ypBlack
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stubImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StabImageStatistic")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bestPeriodLabel = StatisticCustomView()
    private lazy var perfectDaysLabel = StatisticCustomView()
    private lazy var trackersCompletedLabel = StatisticCustomView()
    private lazy var averageValueLabel = StatisticCustomView()
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        updateLabelsValues()
        recordStore.delegate = self
        records = recordStore.records ?? []
        navBarItem()
        setupView()
        setupConstraints()
        showPlaceholder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLabelsValues()
    }
    
    //MARK: - Private Properties
    private func navBarItem() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = NSLocalizedString("Statistics", comment: "")
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
    }
    private func setupView() {
        bestPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        perfectDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
        averageValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stubLabel)
        view.addSubview(stubImageView)
        view.addSubview(bestPeriodLabel)
        view.addSubview(perfectDaysLabel)
        view.addSubview(trackersCompletedLabel)
        view.addSubview(averageValueLabel)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            stubImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stubLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            
            bestPeriodLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            bestPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bestPeriodLabel.heightAnchor.constraint(equalToConstant: 90),
            
            perfectDaysLabel.topAnchor.constraint(equalTo: bestPeriodLabel.bottomAnchor, constant: 12),
            perfectDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            perfectDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            perfectDaysLabel.heightAnchor.constraint(equalToConstant: 90),
            
            trackersCompletedLabel.topAnchor.constraint(equalTo: perfectDaysLabel.bottomAnchor, constant: 12),
            trackersCompletedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCompletedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCompletedLabel.heightAnchor.constraint(equalToConstant: 90),
            
            averageValueLabel.topAnchor.constraint(equalTo: trackersCompletedLabel.bottomAnchor, constant: 12),
            averageValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            averageValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            averageValueLabel.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    private func showPlaceholder() {
        if completedTrackers == nil  {
            stubImageView.isHidden = false
            stubLabel.isHidden = false
            bestPeriodLabel.isHidden = true
            perfectDaysLabel.isHidden = true
            trackersCompletedLabel.isHidden = true
            averageValueLabel.isHidden = true
        } else if completedTrackers == 0 {
            stubImageView.isHidden = false
            stubLabel.isHidden = false
            bestPeriodLabel.isHidden = true
            perfectDaysLabel.isHidden = true
            trackersCompletedLabel.isHidden = true
            averageValueLabel.isHidden = true
        } else {
            stubImageView.isHidden = true
            stubLabel.isHidden = true
            bestPeriodLabel.isHidden = false
            perfectDaysLabel.isHidden = false
            trackersCompletedLabel.isHidden = false
            averageValueLabel.isHidden = false
        }
    }
    
    private func updateLabelsValues() {
        completedTrackers = records.count
        showPlaceholder()
        trackersCompletedLabel.reloadView(number: "\(completedTrackers ?? 0)", name: NSLocalizedString("TrackersCompleted", comment: ""))
        bestPeriodLabel.reloadView(number: "0", name: NSLocalizedString("BestPeriod", comment: ""))
        averageValueLabel.reloadView(number: "0", name: NSLocalizedString("Average", comment: ""))
        perfectDaysLabel.reloadView(number: "0", name: NSLocalizedString("IdealDays", comment: ""))
    }
}

extension StatisticViewController: TrackerRecordDelegate {
    func statisticsDidUpdate() {
        records = recordStore.records ?? []
    }
}
