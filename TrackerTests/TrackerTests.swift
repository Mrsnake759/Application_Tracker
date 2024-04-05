//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by artem on 03.04.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackerViewController()
        assertSnapshot(matching: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDark() {
        let vc = TrackerViewController()
        
        assertSnapshot(matching: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)))
    }

}
