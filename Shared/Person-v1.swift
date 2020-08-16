import Foundation

struct Person: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    
    init(name: String, id: UUID = UUID()) {
        self.name = name
        self.id = id
    }
}

