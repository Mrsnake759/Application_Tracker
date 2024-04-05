//
//  ProtocolScheduleCellDelegate.swift
//  Tracker
//
//  Created by artem on 12.03.2024.
//

import Foundation

protocol ScheduleCellDelegate: AnyObject {
    func switchButtonClicked(to isSelected: Bool, of weekDay: Weekday)
}
