//
//  Album.swift
//  AlgorithmsTask
//
//  Created by Mena Gamal on 7/20/18.
//  Copyright © 2018 Mena Gamal. All rights reserved.
//

import Foundation

class Album {
    
    var id:Int!
    var albumID:Int!
    var title:String!
    var photo:String!
    
    init() {
        
    }
    
    init(json:[String:Any]) {
        if let temp = json["id"] as? Int {
            id = temp
        }
        if let temp = json["albumId"] as? Int {
            albumID = temp
        }
        
        if let temp = json["title"] as? String {
            title = temp
        }
        if let temp = json["url"] as? String {
            photo = temp
        }
       
    }
    
}
