import Foundation

struct PersonFixture {
    
    static func new(_ attrs: [String: Any] = [:]) -> Person {
        let firstName = FixtureTools.unpackString(key: "firstName", attrs: attrs, defaultValue: "Timmy")
        let lastName = FixtureTools.unpackString(key: "lastName", attrs: attrs, defaultValue: "Tester")
        let birthday = FixtureTools.unpackOptionalDate(key: "birthday", attrs: attrs, defaultValue: nil)
        let markAsFavorite = FixtureTools.unpackBool(key: "markAsFavorite", attrs: attrs, defaultValue: false)
        let id = FixtureTools.unpackOptionalUUID(key: "id", attrs: attrs, defaultValue: nil)

        if let id = id {
            return Person(firstName: firstName, lastName: lastName, birthday: birthday, markAsFavorite: markAsFavorite, id: id)
        } else {
            return Person(firstName: firstName, lastName: lastName, birthday: birthday, markAsFavorite: markAsFavorite)
        }
    }
    
}

struct FixtureTools {
    static func unpackString(key: String, attrs: [String: Any], defaultValue: String) -> String {
        if let value = attrs[key] as? String {
            return value
        } else {
            return defaultValue
        }
    }
    
    static func unpackBool(key: String, attrs: [String: Any], defaultValue: Bool) -> Bool {
        if let value = attrs[key] as? Bool {
            return value
        } else {
            return defaultValue
        }
    }
    
    static func unpackOptionalUUID(key: String, attrs: [String: Any], defaultValue: UUID?) -> UUID? {
        if let value = attrs[key] as? UUID {
            return value
        } else {
            return defaultValue
        }
    }
    
    static func unpackOptionalDate(key: String, attrs: [String: Any], defaultValue: Date?) -> Date? {
        if let value = attrs[key] as? Date {
            return value
        } else {
            return defaultValue
        }
    }
}
