//
//  Gnome.swift
//  altran
//
//  Created by Juan S. Landy on 10/7/17.
//
//

import Foundation

public struct Gnome {
    var id = 0
    var name = ""
    var thumbnail = ""
    var age = 0
    var weight = 0.0
    var height = 0.0
    var hair_color = ""
    var proffesions = [""]
    var friends = [""]
    
//    init(id:Int, name:String, thumbnail:String, age:Int, weight: Double, height:Double, hair_color:String, proffesions:[String]?,friends:[String]?) {
//        (self.id, self.name, self.thumbnail, self.age, self.weight, self.height, self.hair_color, self.proffesions, self.friends) = (id, name, thumbnail, age, weight, height, hair_color, proffesions, friends)
//    }
    
//    public init(json: [String: Any]) throws {
//        //1
//        guard let name = json["name"] as? String else {
//                throw SerializationError.missing("name")
//        }
//        guard let link = json["thumbnail"] as? String else {
//                throw SerializationError.missing("thumbnail")
//        }
//        //2
//        (self.id, self.name, self.thumbnail, self.age, self.weight, self.height, self.hair_color, self.proffesions, self.friends) = (json["id"] as! Int, name, link, json["age"] as! Int, json["weight"] as! Double, json["height"] as! Double, json["hair_color"] as! String, json["proffesions"] as? [String], json["friends"] as? [String])
//    }
    
//    enum SerializationError: Error {
//        case missing(String)
//    }
    
    
}
