import Foundation

// Note: These older versions of `Person` are not included in the target
// and are provided for developer reference only.
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
