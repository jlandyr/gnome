//
//  ParseData.swift
//  altran
//
//  Created by Juan S. Landy on 10/7/17.
//
//

import UIKit

class ParseData: NSObject {

    public let urlRequest:URL! = URL(string: "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json")
    var gnomesData :[Gnome] = []
    
    public class func parseAllData(anyObj: [AnyObject]) -> [Gnome]{
        var arrayGnomes: [Gnome] = []
        var gnome = Gnome()
        for obj in anyObj{
            gnome.id  =  (obj["id"]  as AnyObject? as? Int) ?? 0
            gnome.name = (obj["name"] as AnyObject? as? String) ?? "" // to get rid of null
            gnome.thumbnail = (obj["thumbnail"] as AnyObject? as? String) ?? "" // to get rid of null
            gnome.age = (obj["age"] as AnyObject? as? Int) ?? 0
            gnome.weight = (obj["weight"] as AnyObject? as? Double)?.roundTo(places: 1) ?? 0.0
            gnome.height = (obj["height"] as AnyObject? as? Double)?.roundTo(places: 1) ?? 0.0
            gnome.hair_color = (obj["hair_color"] as AnyObject? as? String) ?? ""
            gnome.proffesions = (obj["professions"] as AnyObject? as? [String]) ?? [""]
            gnome.friends = (obj["friends"] as AnyObject? as? [String]) ?? [""]
            
            arrayGnomes.append(gnome)
        }
        return arrayGnomes
    }
    
    func dataToJson(data:Data) -> [Gnome]{
        do{
            let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
            var tableData : [AnyObject]!
            tableData = dic.value(forKey : "Brastlewark") as? [AnyObject]
            self.gnomesData = ParseData.parseAllData(anyObj: tableData)
            return gnomesData

        }
        catch{
            print("something went wrong, try again")
            return gnomesData
        }
        
    }
    
    func getProfessions(list:[Gnome]) -> [String]{
        if list.count > 0
        {
            var profession:[String] = []
            
            if list[0].proffesions.count > 0
            {
                profession.append(removeWhiteSpaceLeftRight(myString:list[0].proffesions[0]))
            }
            
            for obj in list{
                for obj2 in obj.proffesions
                {
                    
                    if profession.contains(removeWhiteSpaceLeftRight(myString: obj2)){}
                    else{
                        profession.append(removeWhiteSpaceLeftRight(myString: obj2))
                    }
                }
            }
            let array = profession.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            return array
            
            
        }
        return [""]
    }
    
    func filterGnomesByProfession(profession:String, gnomeArray:[Gnome]) -> [Gnome]{
        var newArray:[Gnome] = []
        for obj in gnomeArray{
            for obj2 in obj.proffesions{
                if obj2 == profession{
                    newArray.append(obj)
                }
            }
        }
        return newArray
    }
    
    func removeWhiteSpaceLeftRight(myString:String)-> String{
        let trimmedString = myString.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString
    }
    
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
