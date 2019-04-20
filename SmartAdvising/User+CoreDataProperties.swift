//
//  User+CoreDataProperties.swift
//  
//
//  Created by Cameron Farzaneh on 4/3/19.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var major: String?
    @NSManaged public var majorId: Int32
    @NSManaged public var school: String?
    @NSManaged public var undergrad: Bool

}
