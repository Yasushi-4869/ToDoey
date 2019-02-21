//
//  Item.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/20.
//  Copyright © 2019 小田康史. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
