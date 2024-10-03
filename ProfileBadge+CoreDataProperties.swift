//
//  ProfileBadge+CoreDataProperties.swift
//  KindnessApp
//
//  Created by Erin Foley on 2/12/24.
//
//

import Foundation
import CoreData


extension ProfileBadge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileBadge> {
        return NSFetchRequest<ProfileBadge>(entityName: "ProfileBadge")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var milestone: Int64

}

extension ProfileBadge : Identifiable {

}
