import Foundation

// Note: These older versions of `Person` are not included in the target
// and are provided for developer reference only.
struct Person: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    
    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
}

