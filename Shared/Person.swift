import Foundation

struct Person: Codable, Equatable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    // FIXME: Storing a `birthday` as a `Date` is questionable since the time values add confusion and potential bugs.
    // In a production app I'd probably use `DateComponents` and serialize as a string `YYYY-MM-DD`.
    let birthday: Date?
    let markAsFavorite: Bool

    init(firstName: String, lastName: String, birthday: Date?, markAsFavorite: Bool, id: UUID = UUID()) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
        self.markAsFavorite = markAsFavorite
        self.id = id
    }
    
    // `encode` is explicitly written since the default synthesized `encode` would not
    // write optionals like `birthday` as `null` in the JSON.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(birthday, forKey: .birthday)
        try container.encode(markAsFavorite, forKey: .markAsFavorite)
        try container.encode(id, forKey: .id)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case birthday
        case markAsFavorite = "mark_as_favorite"
    }
}
