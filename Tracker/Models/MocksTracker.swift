//
//  MocksTracker.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 17.01.2024.
//

import UIKit

final class MocksTracker {
    static var mocksTrackers: [TrackerCategory] = [
        TrackerCategory(
            headerName: NSLocalizedString("Sports", comment: ""),
            trackerArray: [
                Tracker(id: UUID(),
                        name: NSLocalizedString("Fitness", comment: ""),
                        color: .ypColorSelection1,
                        emoji: "🏃",
                        schedule: [.Tuesday, .Thursday, .Saturday], 
                        pinned: true),
                Tracker(
                    id: UUID(),
                    name: NSLocalizedString("TableTennis", comment: ""),
                    color: .ypColorSelection2,
                    emoji: "🏓",
                    schedule: [.Monday, .Wednesday, .Friday], 
                    pinned: false),
                Tracker(
                    id: UUID(),
                    name: NSLocalizedString("Yoga", comment: ""),
                    color: .ypColorSelection3,
                    emoji: "🧘‍♂️",
                    schedule: [.Monday], 
                    pinned: true),
            ]),
        TrackerCategory(
            headerName: NSLocalizedString("Rest", comment: ""),
            trackerArray: [
                Tracker(
                    id: UUID(),
                    name: NSLocalizedString("ViewingTheMovie", comment: ""),
                    color: .ypColorSelection4,
                    emoji: "📺",
                    schedule: [.Friday, .Saturday], 
                    pinned: true),
                Tracker(
                    id: UUID(),
                    name: NSLocalizedString("MeetingWithFriends", comment: ""),
                    color: .ypColorSelection5,
                    emoji: "🍻",
                    schedule: [.Monday], 
                    pinned: false),
            ])
    ]
}
