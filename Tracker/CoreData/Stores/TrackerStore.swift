//
//  TrackerStore.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 23.01.2024.
//

import UIKit
import CoreData

private enum TrackerStoreError: Error {
    case decodingErrorInvalidModel
}

final class TrackerStore: NSObject  {
    // MARK: - Identifer
    static let shared = TrackerStore()
    // MARK: - Delegate
    weak var delegate: TrackerStoreDelegate?
    // MARK: - Private Properties
    private var trackers: [Tracker] {
        guard
            let objects = self.trackersFetchedResultsController?.fetchedObjects,
            let trackers = try? objects.map({ try convertTrackerFromCoreData($0) }) else {
            return []
        }
        return trackers
    }
    
    private let recordStore = TrackerRecordStore.shared
    private let uiColorMarshalling = UIColorMarshalling()
    private var context: NSManagedObjectContext
    private var trackersFetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    // MARK: - Initializers
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Ошибка с инициализацией AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.trackersFetchedResultsController = controller
        try? controller.performFetch()
    }
    
    // MARK: - Public Methods
    func addCoreDataTracker(_ tracker: Tracker, with category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.identifer = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule as NSObject
        trackerCoreData.category = category
        trackerCoreData.record = []
        trackerCoreData.pinned = tracker.pinned
        try saveContext()
    }
    
    func convertTrackerFromCoreData(_ modelCoreData: TrackerCoreData) throws -> Tracker {
        guard
            let id = modelCoreData.identifer,
            let name = modelCoreData.name,
            let colorString = modelCoreData.color,
            let emoji = modelCoreData.emoji,
            let schedule = modelCoreData.schedule as? [Weekday] else {
            throw TrackerStoreError.decodingErrorInvalidModel
        }
        let color = uiColorMarshalling.color(from: colorString)
        let pinned = modelCoreData.pinned
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            pinned: pinned)
    }
    
    func trackerUpdate(_ record: TrackerRecord) throws {
        let newRecord = recordStore.createCoreDataTrackerRecord(from: record)
        let request = TrackerCoreData.fetchRequest()
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.identifer), record.id as CVarArg)
        
        guard let trackers = try? context.fetch(request) else { return }
        if let trackerCoreData = trackers.first {
            trackerCoreData.addToRecord(newRecord)
            try saveContext()
        }
    }
    
    func pinnedTrackerCoreData(_ tracker: Tracker) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.identifer), tracker.id as CVarArg)
        
        guard let trackerCoreData = try? context.fetch(request) else {
            return
        }
        if let trackerPinned = trackerCoreData.first {
            if trackerPinned.pinned == false {
                trackerPinned.pinned = true
            } else if trackerPinned.pinned == true {
                trackerPinned.pinned = false
            }
            try saveContext()
        }
    }
    
    func deleteTracker(_ model: Tracker) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.identifer), model.id as CVarArg)
        guard let trackers = try? context.fetch(request) else {
            return
        }
        if let tracker = trackers.first {
            context.delete(tracker)
            try saveContext()
        }
    }
    
    func updateTracker(_ updatedTracker: Tracker, with category: TrackerCategoryCoreData) throws {
        guard let trackerToUpdate = trackersFetchedResultsController?.fetchedObjects?.first(where: { $0.identifer == updatedTracker.id }) else {
            return
        }
        trackerToUpdate.name = updatedTracker.name
        trackerToUpdate.category = category
        trackerToUpdate.schedule = updatedTracker.schedule as NSObject
        trackerToUpdate.emoji = updatedTracker.emoji
        trackerToUpdate.color = uiColorMarshalling.hexString(from: updatedTracker.color)
        
        try saveContext()
    }
    // MARK: - Private Methods
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate()
    }
}

