import Foundation

// Used in the UI demo of the app for quick, random people generation.
// I generally like to keep Fixtures out of any production code but these
// two behaviors do overlap a bit.
struct PersonGenerator {
    
    static func randomPerson() -> Person {
        // Only using ! here since this is a demo thing.
        return Person(firstName: firstNames.randomElement()!, lastName: lastNames.randomElement()!, birthday: nil, markAsFavorite: false)
    }
    
    static private let firstNames = [
        "James",
        "John",
        "Robert",
        "Michael",
        "William",
        "David",
        "Richard",
        "Charles",
        "Joseph",
        "Thomas",
        "Christopher",
        "Mary",
        "Patricia",
        "Linda",
        "Barbara",
        "Elizabeth",
        "Jennifer",
        "Maria",
        "Susan",
        "Margaret",
        "Dorothy",
    ]
    
    static private let lastNames = [
        "Prince",
        "Castaneda",
        "Patel",
        "Sawyer",
        "Payne",
        "Valenzuela",
        "Moreno",
        "Mayo",
        "Pineda",
        "Barry",
        "Aguirre",
        "Nielsen",
        "Oneal",
        "Moon",
        "Branch",
        "Figueroa",
        "Mcneil",
        "Shields",
        "Patterson",
        "Booth",
    ]
 }
