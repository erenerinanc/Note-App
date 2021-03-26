//
//  Node.swift
//  Day74Challange
//
//  Created by Eren Erinanc on 16.03.2021.
//

import Foundation

class Note: NSObject, NSCoding {
    var title: String
    var body: String

    init (title: String, body: String) {
        self.title = title
        self.body = body
    }
    
//    this code is writing the things to the disk
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(body, forKey: "body")
    }
    
    
//   this code is reading the things out from disk
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        body = aDecoder.decodeObject(forKey: "body") as? String ?? ""
    }

}
