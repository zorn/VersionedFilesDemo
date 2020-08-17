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
    
    init(data: Data, expectedSchemaVersion: Int?) throws {
        
        let detectedSchemaVersion = try PeopleDocumentFileRepresentation.self.detectedSchemaVersion(data: data, expectedSchemaVersion: expectedSchemaVersion)
        
        let decoder = PeopleDocumentFileRepresentation.self.decoder
        
        // FIXME: Can I compare the enum values directly or do I have to use `rawValue`?
        if detectedSchemaVersion.rawValue < CURRENT_SCHEMA_VERSION.rawValue {
            let migratedData = try PeopleDocumentFileRepresentation.self.migrateData(data)
            self = try decoder.decode(PeopleDocumentFileRepresentation.self, from: migratedData)
        } else {
            self = try decoder.decode(PeopleDocumentFileRepresentation.self, from: data)
        }
    }
    
    func data() throws -> Data {
        try type(of: self).encoder.encode(self)
    }
    
    /// Given the data content and an optional `expectedSchemaVersion` which may have been provided
    /// from a fileAttribute, return the detectedSchemaVersion.
    /// This function was written to help optimize behavior when the schemaVersion was correctly recorded and read from
    /// the `FileWrapper`'s `fileAttributes` and help us avoid sniffing the schemaVersion from the contents
    /// of the file (which is expensive).
    private static func detectedSchemaVersion(data: Data, expectedSchemaVersion: Int?) throws -> KnownSchemaVersions {
        if
            let expectedSchemaVersion = expectedSchemaVersion,
            let detectedSchemaVersion = KnownSchemaVersions(rawValue: expectedSchemaVersion)
        {
            return detectedSchemaVersion
        } else {
            return try schemaVersionOf(data)
        }
    }
    
    private static func migrateData(_ data: Data) throws -> Data {
        guard let jsonContent = try JSONSerialization.jsonObject(with: data) as? JSONContent else {
            throw MigrationError.unexpectedFormat
        }
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
    
    private static func schemaVersionOf(_ data: Data) throws -> KnownSchemaVersions {
        guard let jsonContent = try JSONSerialization.jsonObject(with: data) as? JSONContent else {
            throw MigrationError.unexpectedFormat
        }
        return try schemaVersionOf(jsonContent)
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
