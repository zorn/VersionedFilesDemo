import Foundation

extension PeopleDocumentFileRepresentation {
    struct MigrateV2ToV3swift {
        static func migrate(_ jsonContent: JSONContent) throws -> JSONContent {
            var mutableContent = jsonContent
            
            guard var people = mutableContent["people"] as? [JSONContent] else {
                throw PeopleDocumentFileRepresentation.MigrationError.missingKey("people")
            }
            
            for personIndex in people.indices {
                people[personIndex].updateValue(nil, forKey: "birthday")
                people[personIndex].updateValue(false, forKey: "mark_as_favorite")
            }
            
            mutableContent.updateValue(people, forKey: "people")
            mutableContent.updateValue(3, forKey: "schema_version")
            
            return mutableContent
        }
    }
}
