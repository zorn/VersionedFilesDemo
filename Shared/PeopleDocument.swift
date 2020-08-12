import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct PeopleDocument: FileDocument {
    var people: [Person]

    init(people: [Person]) {
        self.people = people
    }

    static var readableContentTypes: [UTType] { [.exampleText] }

    init(fileWrapper: FileWrapper, contentType: UTType) throws {
        guard
            let data = fileWrapper.regularFileContents,
            let people = try? JSONDecoder().decode([Person].self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.people = people
    }
    
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
        do {
            let data = try JSONEncoder().encode(people)
            fileWrapper = FileWrapper(regularFileWithContents: data)
        } catch {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
}
