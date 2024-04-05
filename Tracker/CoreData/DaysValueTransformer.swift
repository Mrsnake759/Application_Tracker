//
//  DaysValueTransformer.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 23.01.2024.
//

import Foundation

@objc(DaysTransformer)
final class DaysTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        NSArray.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(DaysTransformer(), forName: NSValueTransformerName(rawValue: String(describing: DaysTransformer.self)))
    }
}
