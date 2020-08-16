import Foundation

extension PeopleDocumentFileRepresentation {
    struct MigrateV1ToV2swift {
        static func migrate(_ jsonContent: JSONContent) throws -> JSONContent {
            
            var mutableContent = jsonContent
            
            guard var people = mutableContent["people"] as? [[String:Any]] else {
                throw PeopleDocumentFileRepresentation.MigrationError.missingKey("people")
            }
            
            for personIndex in people.indices {
                guard let fullName = people[personIndex]["name"] as? String else {
                    throw PeopleDocumentFileRepresentation.MigrationError.missingKey("name")
                }
                
                // This conversion of `name` into `first_name` and `last_name` is not very complete
                // but a bullet proof solution is outside the scope of this demo.
                if
                    let firstName: Substring = fullName.split(separator: " ").first,
                    let lastName: Substring = fullName.split(separator: " ").last
                {
                    people[personIndex].updateValue(String(firstName), forKey: "first_name")
                    people[personIndex].updateValue(String(lastName), forKey: "last_name")
                    people[personIndex].removeValue(forKey: "name")
                } else {
                    // If we can not split the name into two parts, just put the whole thing in `first_name`.
                    people[personIndex].updateValue(fullName, forKey: "first_name")
                    people[personIndex].removeValue(forKey: "name")
                }
            }
            mutableContent.updateValue(people, forKey: "people")
            mutableContent.updateValue(2, forKey: "schema_version")
            
            return mutableContent
        }
    }
}
