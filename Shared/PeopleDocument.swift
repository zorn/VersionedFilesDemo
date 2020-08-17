import SwiftUI
import UniformTypeIdentifiers

struct PeopleDocument: FileDocument {
    
    /// Documents the type of file `PeopleDocument` knows how to read (and write).
    /// A requirement of the `FileDocument` protocol.
    static var readableContentTypes: [UTType] { [.peopleDocumentType] }
    
    /// Stores the ordered collection of of `Person` objects this document will manage.
    var people: [Person]
    
    init(people: [Person]) {
        self.people = people
    }

    init(fileWrapper: FileWrapper, contentType: UTType) throws {
        guard let data = fileWrapper.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        print(fileWrapper.fileAttributes)
        // Not seeing the written "schema_version" :(
        // ["NSFileModificationDate": 2020-08-17 00:16:50 +0000, "NSFileType": NSFileTypeRegular, "NSFilePosixPermissions": 438]

        
        // FIXME: No String keys.
        let expectedSchemaVersion = fileWrapper.fileAttributes["schema_version"] as? Int
        let fileRep = try PeopleDocumentFileRepresentation(data: data, expectedSchemaVersion: expectedSchemaVersion)
        self.people = fileRep.people
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
        do {
            let fileRep = PeopleDocumentFileRepresentation(people: self.people)
            // FIXME: Not sure if it's best to let a `DecodingError` error be thrown here,
            // but it does help debugging. Need to test how `FileDocument` will present
            // such an error.
            let fileRepData = try fileRep.data()
            fileWrapper = FileWrapper(regularFileWithContents: fileRepData)
            // FIXME: No string keys.
            fileWrapper.fileAttributes.updateValue(fileRep.schemaVersion.rawValue, forKey: "schema_version")
            
            print(fileWrapper.fileAttributes)
            // It is being stored, eg:
            // ["NSFileModificationDate": 2020-08-17 00:16:54 +0000, "NSFileType": NSFileTypeRegular, "schema_version": 3, "NSFilePosixPermissions": 438]

            
            
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
}

extension UTType {
    static var peopleDocumentType: UTType {
        UTType(importedAs: "com.zornlabs.version-file-demo.people")
    }
}
