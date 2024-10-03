//
//  KindnessAct+CoreDataProperties.swift
//  KindnessApp
//
//  Created by Erin Foley on 2/12/24.
//
//

import Foundation
import CoreData


extension KindnessAct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KindnessAct> {
        return NSFetchRequest<KindnessAct>(entityName: "KindnessAct")
    }

    @NSManaged public var imageName: String?
    @NSManaged public var points: Int64
    @NSManaged public var name: String?

}

extension KindnessAct : Identifiable {

}
