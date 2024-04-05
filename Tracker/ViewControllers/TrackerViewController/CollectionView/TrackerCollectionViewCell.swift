//
//  TrackersCollectionCell.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 17.01.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    //MARK: - Delegate:
    weak var delegate: TrackerCellDelegate?
    //MARK: - Identifer:
    static let identifier = "TrackersCell"
    // MARK: - Private Properties:
    private let plusButtonImage = UIImage(named: "PlusTask")
    private let doneButtonImage = UIImage(named: "DoneCollectionButton")
    private var trackerIdentifer: UUID? = nil
    private var isCompleted: Bool = false
    private var indexPath: IndexPath?
    var isPinned: Bool = false
    public var preview: UIView {
        return trackerView
    }
    public var id: UUID? {
        return trackerIdentifer ?? nil
    }
    //MARK: - UI:
    private lazy var trackerView: UIView = {
        var view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dayAndButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dayLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var plusButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = trackerView.backgroundColor
        button.tintColor = .ypWhite
        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .ypBackEmoji
        label.font = .systemFont(ofSize: 16)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 14
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textTrackerLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pinnedImageView: UIImageView = {
        let pinnedImage = UIImage(named: "pin")
        let imageView = UIImageView(image: pinnedImage)
        imageView.layer.backgroundColor = UIColor.clear.cgColor
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Public Methods:
    func cellSettings(id: UUID,
                      name: String,
                      color: UIColor,
                      emoji: String,
                      completedDays: Int,
                      isEnabled: Bool,
                      isCompleted: Bool,
                      isPinned: Bool) {
        let dayString = NSLocalizedString("numberDays", comment: "")
        let localizedDay = String.localizedStringWithFormat(dayString, completedDays)
        self.trackerIdentifer = id
        self.textTrackerLabel.text = name
        self.trackerView.backgroundColor = color
        self.plusButton.backgroundColor = color
        self.emojiLabel.text = emoji
        self.dayLabel.text = localizedDay
        self.plusButton.isEnabled = isEnabled
        self.isCompleted = isCompleted
        self.isPinned = isPinned
        let image = isCompleted ? doneButtonImage : plusButtonImage
        plusButton.setImage(image, for: .normal)
        plusButton.alpha = isCompleted ? 0.3 : 1
        
        pinnedImageView.isHidden = !isPinned
    }
    // MARK: - Private Methods:
    private func configureCell() {
        contentView.addSubview(trackerView)
        contentView.addSubview(dayAndButtonView)
        trackerView.addSubview(emojiLabel)
        trackerView.addSubview(textTrackerLabel)
        trackerView.addSubview(pinnedImageView)
        dayAndButtonView.addSubview(dayLabel)
        dayAndButtonView.addSubview(plusButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            trackerView.widthAnchor.constraint(equalToConstant: 167),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: 28),
            emojiLabel.widthAnchor.constraint(equalToConstant: 28),
            
            textTrackerLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            textTrackerLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            textTrackerLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            textTrackerLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            pinnedImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -4),
            pinnedImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            pinnedImageView.widthAnchor.constraint(equalToConstant: 24),
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),
            
            dayAndButtonView.topAnchor.constraint(equalTo: trackerView.bottomAnchor),
            dayAndButtonView.widthAnchor.constraint(equalToConstant: 167),
            dayAndButtonView.heightAnchor.constraint(equalToConstant: 58),
            dayLabel.topAnchor.constraint(equalTo: dayAndButtonView.topAnchor, constant: 8),
            dayLabel.leadingAnchor.constraint(equalTo: dayAndButtonView.leadingAnchor, constant: 12),
            dayLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            dayLabel.bottomAnchor.constraint(equalTo: dayAndButtonView.bottomAnchor, constant: -16),
            
            plusButton.topAnchor.constraint(equalTo: dayAndButtonView.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: dayAndButtonView.trailingAnchor, constant: -12),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    //  MARK: - Objc Methods:
    @objc private func plusButtonTapped() {
        guard let id = trackerIdentifer else { return }
        delegate?.trackerCompleted(for: id)
    }
}
