//
//  ProtocolScheduleCellDelegate.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 19.01.2024.
//

import Foundation

protocol ScheduleCellDelegate: AnyObject {
    func switchButtonClicked(to isSelected: Bool, of weekDay: Weekday)
}
