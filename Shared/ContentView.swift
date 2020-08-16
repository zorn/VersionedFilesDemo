import SwiftUI

struct ContentView: View {
    @Binding var document: PeopleDocument
        
    var body: some View {
        NavigationView {
            List {
                ForEach(document.people) { person in
                    Text(fullName(firstName: person.firstName, lastName: person.lastName))
                }
            }
            .navigationBarTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New") {
                        document.people.append(PersonGenerator.randomPerson())
                    }
                }
            }
        }
    }
    
    private func fullName(firstName: String, lastName: String) -> String {
        let nameFormatter = PersonNameComponentsFormatter()
        var nameComponents = PersonNameComponents()
        nameComponents.givenName = firstName
        nameComponents.familyName = lastName
        return nameFormatter.string(from: nameComponents)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(PeopleDocument(people: [])))
    }
}
