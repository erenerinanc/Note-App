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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(body, forKey: "body")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        body = aDecoder.decodeObject(forKey: "body") as? String ?? ""
    }

}
