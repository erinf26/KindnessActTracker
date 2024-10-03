//
//  DataController.swift
//  KindnessApp
//
//  Created by Erin Foley on 1/21/24.
//
import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "KindnessApp")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        // Call this method to populate initial data
        populateInitialData()
    }
    
    func populateInitialData() {
        let context = container.viewContext
        
        // Check if data already exists
        let fetchRequest: NSFetchRequest<KindnessAct> = KindnessAct.fetchRequest()
        let count = try? context.count(for: fetchRequest)
        
        if count == 0 {
            let acts = [
                ("Help a friend with their homework", 50, "homework"),
                ("Pick up trash in a local park", 100, "trashPickUp"),
                ("Thank a facilities worker", 150, "gratitude")
            ]
            
            for (name, points, imageName) in acts {
                let act = KindnessAct(context: context)
                act.name = name
                act.points = Int64(points)
                act.imageName = imageName
            }
            
            // Create initial user profile
            let userProfile = UserProfile(context: context)
            userProfile.totalPoints = 0
            
            do {
                try context.save()
            } catch {
                print("Failed to populate initial data: \(error)")
            }
        }
    }
}
