//
//  Image+CoreDataProperties.swift
//  CoreDataLearn
//
//  Created by Nguyễn Xuân Đạt on 2/13/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSObject?
    @NSManaged public var toItem: Item?

}
