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
        let fileRep = try PeopleDocumentFileRepresentation(data: data)
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
