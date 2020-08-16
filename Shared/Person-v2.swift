import Foundation

struct Person: Codable, Equatable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String

    init(firstName: String, lastName: String, id: UUID = UUID()) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }
}
