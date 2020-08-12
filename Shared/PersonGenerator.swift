import Foundation

struct PersonGenerator {
    
    static func randomPerson() -> Person {
        // Only using ! here since this is a demo thing.
        let randomName = "\(firstNames.randomElement()!) \(lastNames.randomElement()!)"
        return Person(name: randomName)
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
