//
//  ContentView.swift
//  Shared
//
//  Created by zorn on 8/12/20.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PeopleDocument
    
    var body: some View {
        NavigationView {
            List {
                ForEach(document.people) { person in
                    Text(person.name)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(PeopleDocument(people: [])))
    }
}
