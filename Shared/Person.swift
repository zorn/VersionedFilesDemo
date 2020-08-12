import Foundation

struct Person: Identifiable {
    let id: UUID
    let name: String
    
    init(name: String, id: UUID = UUID()) {
        self.id = id
        self.name = name
    }
}

extension Person: Codable {
    
}
