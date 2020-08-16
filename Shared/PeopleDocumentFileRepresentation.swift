import Foundation

/// A structured way to document the known file schema versions.
enum KnownSchemaVersions: Int, Codable {
    case v1 = 1
    case v2 = 2
    case v3 = 3
}
/// A hard coded, gloal reference to the currently supported schema version
/// that `PeopleDocumentFileRepresentation` is setup to work with.
let CURRENT_SCHEMA_VERSION = KnownSchemaVersions.v3

/// All valid schema formats will use JSON content that use a root dictionary with String-based keys.
typealias JSONContent = [String: Any?]

/// When `PeopleDocument` wants to read or write files to disk it will use this file represenation.
struct PeopleDocumentFileRepresentation {
    
    enum MigrationError: Error {
        case unexpectedFormat
        case missingSchemaVersion
        case missingKey(String)
    }
    
    var schemaVersion: KnownSchemaVersions {
        didSet {
            // This `didSet` is here to help us debug.
            // `assertionFailure` is a no-op in a production build.
            if schemaVersion != CURRENT_SCHEMA_VERSION {
                assertionFailure("Unexpected value for schema version.")
            }
        }
    }
    var people: [Person]
    
    init(people: [Person]) {
        self.schemaVersion = CURRENT_SCHEMA_VERSION
        self.people = people
    }
    
    init(data: Data) throws {
        let migratedData = try PeopleDocumentFileRepresentation.self.migrateData(data)
        let decoder = PeopleDocumentFileRepresentation.self.decoder
        self = try decoder.decode(PeopleDocumentFileRepresentation.self, from: migratedData)
    }
    
    func data() throws -> Data {
        try type(of: self).encoder.encode(self)
    }
    
    private static func migrateData(_ data: Data) throws -> Data {
        // FIXME: It feels expensive to import the data into a in-memory JSONContent just to verify the `schema_version`.
        guard let jsonContent = try JSONSerialization.jsonObject(with: data) as? JSONContent else {
            throw MigrationError.unexpectedFormat
        }
        // Only feed the `jsonContent` to the migrators if the current version does not match.
        let currentDataVersion = try PeopleDocumentFileRepresentation.self.schemaVersionOf(jsonContent)
        if currentDataVersion == CURRENT_SCHEMA_VERSION {
            return data
        } else {
            return try JSONSerialization.data(withJSONObject: migrateJSONContent(jsonContent))
        }
    }
    
    private static func migrateJSONContent(_ jsonContent: JSONContent) throws -> JSONContent {
        let currentDataVersion = try PeopleDocumentFileRepresentation.self.schemaVersionOf(jsonContent)
        switch currentDataVersion {
        case .v1:
            return try migrateJSONContent(MigrateV1ToV2swift.migrate(jsonContent))
        case .v2:
            return try migrateJSONContent(MigrateV2ToV3swift.migrate(jsonContent))
        case .v3:
            return jsonContent
        }
    }
    
    private static func schemaVersionOf(_ jsonContent: JSONContent) throws -> KnownSchemaVersions {
        if
            // FIXME: Should avoid using String keys.
            let schemaVersionValue = jsonContent["schema_version"] as? Int,
            let schemaVersion = KnownSchemaVersions.init(rawValue: schemaVersionValue)
        {
            return schemaVersion
        } else {
            throw MigrationError.missingSchemaVersion
        }
    }
}

extension PeopleDocumentFileRepresentation: Codable {
    enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case people
    }
}

extension PeopleDocumentFileRepresentation {
    fileprivate static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    fileprivate static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
