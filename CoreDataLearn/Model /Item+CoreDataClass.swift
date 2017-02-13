//
//  Item+CoreDataClass.swift
//  CoreDataLearn
//
//  Created by Nguyễn Xuân Đạt on 2/13/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    public override func awakeFromInsert() {
        self.create = NSDate()
    }
}
