//
//  CollectionSettings.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 17.01.2024.
//

import Foundation

struct CollectionSettings {
    let cellsQuantity: Int
    let rightInset: CGFloat
    let leftInset: CGFloat
    let cellSpacing: CGFloat

    var paddingWidth: CGFloat {
        return cellSpacing * CGFloat(cellsQuantity - 1) + leftInset + rightInset
    }
}
