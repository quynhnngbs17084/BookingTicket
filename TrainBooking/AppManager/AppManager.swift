
import Foundation
import CoreData

class AppManager {
    // singleton
    static let shared = AppManager()
    
     init() {
        if let lastTripID = PDefaults.object(forKey: "tripID") as? Int {
            self.lastTripID = lastTripID
        } else {
            lastTripID = 0
        }
        
        if let userID = PDefaults.object(forKey: "userID") as? Int {
            self.userID = userID
        } else {
            userID = 0
        }
    }
    
    var isAdmin = true
    var userInfo: NSManagedObject?
    
    var lastTripID: Int {
        didSet {
            PDefaults.set(lastTripID, forKey: "tripID")
        }
    }
    
    var userID: Int {
        didSet {
            PDefaults.set(userID, forKey: "userID")
        }
    }
    
}


struct PDefaults {

    static let SETTINGS = UserDefaults.standard

    static func set(_ object: Any?, forKey key: String) {
        if let value = object {
            SETTINGS.set(value, forKey: key)
        } else {
            SETTINGS.removeObject(forKey: key)
        }
    }

    static func get(_ key: String) -> Any? {
        return SETTINGS.object(forKey: key)
    }


    // Object
    static func object(forKey key: String) -> Any? {
        return SETTINGS.object(forKey: key)
    }

    //
    static func removeObject(forKey key: String) {
        SETTINGS.removeObject(forKey: key)
    }

    
}
