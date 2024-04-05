//
//  ProtocolScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by artem on 12.03.2024.
//

import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    var selectWeekDays: [Weekday] { get set }
    func didSelectDays()
}
