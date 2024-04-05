//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Ivan Cherkashin on 23.01.2024.
//

import UIKit
import CoreData

private enum TrackerRecordStoreError: Error {
    case failedCreateNewRecord
    case failedFetchRecords
}

final class TrackerRecordStore: NSObject {
    // MARK: - Identifer
    static let shared = TrackerRecordStore()
    //MARK: - Delegate
    weak var delegate: TrackerRecordDelegate?
    // MARK: - Public Properties
    var records: [TrackerRecord]? {
        guard
            let fetchedResultController = self.recordsFetchedResultsController,
            let objects = fetchedResultController.fetchedObjects,
            let records = try? objects.map({ try createNewRecord($0) }) else {
            return []
        }
        return records
    }
    // MARK: - Private Properties
    private var context: NSManagedObjectContext
    private var recordsFetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    // MARK: - Initializers:
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
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "identifer", ascending: false)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.recordsFetchedResultsController = controller
        try? controller.performFetch()
    }
    // MARK: - Public Methods
    func createCoreDataTrackerRecord(from record: TrackerRecord) -> TrackerRecordCoreData {
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.date = record.date
        newTrackerRecord.identifer = record.id
        return newTrackerRecord
    }
    
    func removeRecordCoreData(_ id: UUID, with date: Date) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        let trackerRecords = try context.fetch(request)
        let filterRecord = trackerRecords.first {
            $0.identifer == id && $0.date == date
        }
        if let trackerRecordCoreData = filterRecord {
            context.delete(trackerRecordCoreData)
            try saveContext()
        }
    }
    
    func deleteRecordFromCoreData(_ id: UUID) throws {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.identifer), id as CVarArg)
        guard let trackersRecords = try? context.fetch(request) else {
            return
        }
        trackersRecords.forEach {
            context.delete($0)
        }
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
    
    private func createNewRecord(_ recordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let identifier = recordCoreData.identifer,
            let date = recordCoreData.date else {
            throw TrackerRecordStoreError.failedCreateNewRecord
        }
        let trackerRecord = TrackerRecord(id: identifier, date: date)
        return trackerRecord
    }
    
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let delegate = delegate {
            delegate.statisticsDidUpdate()
        }
    }
}

