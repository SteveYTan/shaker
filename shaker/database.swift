//
//  database.swift
//  shaker
//
//  Created by Steve T on 8/17/15.
//  Copyright © 2015 Steve T. All rights reserved.
//

import Foundation
class Database {
    // get the full path to the Documents folder
    static func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as! [String]
        return paths[0]
    }
    // get the full path to file of project
    static func dataFilePath(schema: String) -> String {
        return "\(Database.documentsDirectory())/\(schema)"
    }
    static func save(arrayOfObjects: [AnyObject], toSchema: String, forKey: String) {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(arrayOfObjects, forKey: "\(forKey)")
        archiver.finishEncoding()
        data.writeToFile(Database.dataFilePath(toSchema), atomically: true)
    }
}


class Person: NSObject, NSCoding {
    static var key: String = "People"
    static var schema: String = "theList"
    var objective: String
    var createdAt: NSDate
    // use this init for creating a new Task
    init(obj: String) {
        objective = obj
        createdAt = NSDate()
    }
    // MARK: - NSCoding protocol
    // used for encoding (saving) objects
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(objective, forKey: "objective")
        aCoder.encodeObject(createdAt, forKey: "createdAt")
    }
    // used for decoding (loading) objects
    required init?(coder aDecoder: NSCoder) {
        objective = aDecoder.decodeObjectForKey("objective") as! String
        createdAt = aDecoder.decodeObjectForKey("createdAt") as! NSDate
        super.init()
    }
    // MARK: - Queries
    static func all() -> [Person] {
        var people = [Person]()
        let path = Database.dataFilePath("theList")
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                people = unarchiver.decodeObjectForKey(Person.key) as! [Person]
                unarchiver.finishDecoding()
            }
        }
        return people
    }
    func save() {
        var peopleFromStorage = Person.all()
        var exists = false
        for var i = 0; i < peopleFromStorage.count; ++i {
            if peopleFromStorage[i].createdAt == self.createdAt {
                peopleFromStorage[i] = self
                exists = true
            }
        }
        if !exists {
            peopleFromStorage.append(self)
        }
        Database.save(peopleFromStorage, toSchema: Person.schema, forKey: Person.key)
    }
    func destroy() {
        var peopleFromStorage = Person.all()
        for var i = 0; i < peopleFromStorage.count; ++i {
            if peopleFromStorage[i].createdAt == self.createdAt {
                peopleFromStorage.removeAtIndex(i)
            }
        }
        Database.save(peopleFromStorage, toSchema: Person.schema, forKey: Person.key)
    }
}