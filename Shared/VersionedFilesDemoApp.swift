import SwiftUI

@main
struct VersionedFilesDemoApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: PeopleDocument(people: [])) { file in
            ContentView(document: file.$document)
        }
    }
}
