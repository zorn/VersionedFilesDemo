import XCTest
import UniformTypeIdentifiers
@testable import VersionedFilesDemo

class PeopleDocumentTests: XCTestCase {
    
    func test_peopleDocument_canSave_withTwoPeople() throws {        
        let fred = PersonFixture.new(["firstName": "Fred", "lastName": "Weasley", "birthday": Date.distantPast])
        let george = PersonFixture.new(["firstName": "George", "lastName": "Weasley"])
        let document = PeopleDocument(people: [fred, george])
        var fileWrapper = FileWrapper(regularFileWithContents: Data())
        try document.write(to: &fileWrapper, contentType: UTType.peopleDocumentType)
        let contents = String(data: fileWrapper.regularFileContents!, encoding: .utf8)!
        let expectedContents = """
        {
          "people" : [
            {
              "birthday" : "0001-01-01T00:00:00Z",
              "first_name" : "Fred",
              "id" : "\(fred.id.uuidString)",
              "last_name" : "Weasley",
              "mark_as_favorite" : false
            },
            {
              "birthday" : null,
              "first_name" : "George",
              "id" : "\(george.id.uuidString)",
              "last_name" : "Weasley",
              "mark_as_favorite" : false
            }
          ],
          "schema_version" : 3
        }
        """
        XCTAssertEqual(contents, expectedContents)
    }
    
    func test_peopleDocument_canOpen_withTwoPeople() throws {
        let document = PeopleDocumentFixtures.simpleV3
        XCTAssertEqual(document.people.count, 2)
        let fred = document.people[0]
        XCTAssertEqual(fred.id.uuidString, "4E966EDD-893C-4F96-973A-949411B50149")
        XCTAssertEqual(fred.firstName, "Fred")
        XCTAssertEqual(fred.lastName, "Weasley")
        XCTAssertEqual(fred.birthday, Date.distantPast)
        XCTAssertEqual(fred.markAsFavorite, false)
        
        let george = document.people[1]
        XCTAssertEqual(george.id.uuidString, "4545A339-A09F-4AEE-BE46-1C4FCF6466AA")
        XCTAssertEqual(george.firstName, "George")
        XCTAssertEqual(george.lastName, "Weasley")
        XCTAssertEqual(george.birthday, nil)
        XCTAssertEqual(george.markAsFavorite, false)
    }
    
    func test_peopleDocument_canOpen_version1FileFormat() throws {
        let document = PeopleDocumentFixtures.simpleV1
        XCTAssertEqual(document.people.count, 2)
        let fred = document.people[0]
        XCTAssertEqual(fred.id.uuidString, "4E966EDD-893C-4F96-973A-949411B50149")
        XCTAssertEqual(fred.firstName, "Fred")
        XCTAssertEqual(fred.lastName, "Weasley")
        XCTAssertEqual(fred.birthday, nil)
        XCTAssertEqual(fred.markAsFavorite, false)
        
        let george = document.people[1]
        XCTAssertEqual(george.id.uuidString, "4545A339-A09F-4AEE-BE46-1C4FCF6466AA")
        XCTAssertEqual(george.firstName, "George")
        XCTAssertEqual(george.lastName, "Weasley")
        XCTAssertEqual(george.birthday, nil)
        XCTAssertEqual(george.markAsFavorite, false)
    }
}
