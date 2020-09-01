import Foundation
import SwiftUI
import UniformTypeIdentifiers
@testable import VersionedFilesDemo

struct PeopleDocumentFileRepresentationFixtures {
    
    static var simpleV1: PeopleDocumentFileRepresentation {
        return try! PeopleDocumentFileRepresentation(data: simple(version: 1))
    }
    
    static var simpleV2: PeopleDocumentFileRepresentation {
        return try! PeopleDocumentFileRepresentation(data: simple(version: 2))
    }
    
    static var simpleV3: PeopleDocumentFileRepresentation {
        return try! PeopleDocumentFileRepresentation(data: simple(version: 3))
    }
    
    private static func simple(version: Int) -> Data {
        let testBundle = Bundle(for: PeopleDocumentTests.self)
        let filename = "simple-v\(version)"
        let url = testBundle.url(forResource: filename, withExtension: "people")!
        return try! Data(contentsOf: url)
    }
    
}
