import Foundation
import SwiftUI
import UniformTypeIdentifiers
@testable import VersionedFilesDemo

struct PeopleDocumentFixtures {
    
    static var simpleV1: PeopleDocument {
        let configuration = PeopleDocument.ReadConfiguration(contentType: UTType.peopleDocumentType, file: simple(version: 1))
        return try! PeopleDocument(configuration: configuration)
    }
    
    static var simpleV2: PeopleDocument {
        return try! PeopleDocument(fileWrapper: simple(version: 2), contentType: UTType.peopleDocumentType)
    }
    
    static var simpleV3: PeopleDocument {
        return try! PeopleDocument(fileWrapper: simple(version: 3), contentType: UTType.peopleDocumentType)
    }
    
    private static func simple(version: Int) -> FileWrapper {
        let testBundle = Bundle(for: PeopleDocumentTests.self)
        let filename = "simple-v\(version)"
        let url = testBundle.url(forResource: filename, withExtension: "people")!
        let fileWrapper = try! FileWrapper(url: url)
        return fileWrapper;
    }
    
}
