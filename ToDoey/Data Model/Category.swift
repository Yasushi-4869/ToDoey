//
//  Category.swift
//  ToDoey
//
//  Created by 小田康史 on 2019/02/20.
//  Copyright © 2019 小田康史. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}
