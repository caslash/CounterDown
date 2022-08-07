//
//  DataController.swift
//  CounterKit
//
//  Created by Cameron Slash on 27/6/22.
//

import CoreData
import Foundation
import UIKit

public class DataController: ObservableObject {
    public static var shared = DataController()
    public static let preview: DataController = {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Could not create preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    public let container: NSPersistentCloudKitContainer
    
    private enum RefreshStatus {
        case success, failure
    }
    
    init(inMemory: Bool = false) {
        let momdName = "CounterDownModel"
        
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let container = NSPersistentCloudKitContainer(name: "CounterDownModel", managedObjectModel: mom)
        
        if !inMemory {
            guard let description = container.persistentStoreDescriptions.first else {
                fatalError("No Descriptions Found")
            }
            description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.Cameron.Slash.CounterDown")
        } else {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        self.container = container

        NotificationCenter.default.addObserver(self, selector: #selector(self.processUpdate), name: .NSPersistentStoreRemoteChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.processRefresh), name: .CDEventEnded, object: nil)
    }
    
    public func save() {
        if self.container.viewContext.hasChanges { try? self.container.viewContext.save() }
    }
    
    public func delete(_ object: NSManagedObject) {
        self.container.viewContext.delete(object)
    }
    
    public func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = SavedEvent.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }
    
    @objc
    func processUpdate(notification: NSNotification) {
        operationQueue.addOperation {
            let context = self.container.newBackgroundContext()
            context.performAndWait {
                var events: [SavedEvent]
                do {
                    try events = context.fetch(SavedEvent.getSavedEventFetchRequest())
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
                events.sort {
                    $0.due! < $1.due!
                }
                
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        }
    }
    
    @objc
    public func processRefresh(notification: Notification) {
        let context = self.container.newBackgroundContext()
        let event = notification.userInfo!["event"] as! SavedEvent
        
        context.perform {
            let refreshResult = self.handleEventsRefresh(event)
            
            if refreshResult == .success {
                self.save()
            } else {
                fatalError("Couldn't handle refresh.")
            }
        }
    }
    
    private func handleEventsRefresh(_ event: SavedEvent) -> RefreshStatus {
        if !event.isRecurring {
            self.delete(event)
        } else {
            event.due = Calendar.current.date(byAdding: event.eventRecurrenceInterval.component!, value: event.eventRecurrenceInterval.offset, to: event.eventDueDate)
        }
        
        if self.container.viewContext.hasChanges {
            return .success
        }
        return .failure
    }
    
    lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    func createSampleData() throws {
        let viewContext = self.container.viewContext
        
        let components: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        
        for i in 1...5 {
            let event = SavedEvent(context: viewContext)
            event.id = UUID()
            event.name = "Event \(i)"
            event.due = Calendar.current.date(byAdding: .day, value: Int.random(in: 10..<365), to: Date())
            event.colorHex = String(format: "#%6x", Int.random(in: 0...16777215))
            event.components = try JSONEncoder().encode(components)
            event.isRecurring = Bool.random()
            if event.isRecurring {
                event.recurrenceInterval = Int16.random(in: 1...5)
            }
        }
        
        try viewContext.save()
    }
}

