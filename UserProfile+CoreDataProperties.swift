//
//  UserProfile+CoreDataProperties.swift
//  KindnessApp
//
//  Created by Erin Foley on 2/12/24.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var totalPoints: Int64
    @NSManaged public var badges: NSSet?

}

// MARK: Generated accessors for badges
extension UserProfile {

    @objc(addBadgesObject:)
    @NSManaged public func addToBadges(_ value: ProfileBadge)

    @objc(removeBadgesObject:)
    @NSManaged public func removeFromBadges(_ value: ProfileBadge)

    @objc(addBadges:)
    @NSManaged public func addToBadges(_ values: NSSet)

    @objc(removeBadges:)
    @NSManaged public func removeFromBadges(_ values: NSSet)

}

extension UserProfile : Identifiable {

}
