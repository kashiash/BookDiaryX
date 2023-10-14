//
//  BookSamples.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 14/10/2023.
//

import Foundation

extension Book {

static var sampleBooks:  [Book] {

    // Define arrays of first names and last names
    let firstNames = ["John", "Emily", "Michael", "Sophia", "William", "Olivia", "James", "Ava", "Daniel", "Charlotte"]
    let lastNames = ["Smith", "Johnson", "Brown", "Davis", "Wilson", "Anderson", "Garcia", "Martinez", "Lee", "Harris"]

    // Function to generate a random name
    func generateRandomName() -> String {
        let randomFirstName = firstNames.randomElement() ?? ""
        let randomLastName = lastNames.randomElement() ?? ""

        return "\(randomFirstName) \(randomLastName)"
    }

    let adjectives = ["Red", "Happy", "Mysterious", "Brilliant", "Gentle", "Wild"]
    let nouns = ["Fox", "Sun", "Mountain", "Ocean", "Castle", "Dream"]
    let verbs = ["Dances", "Laughs", "Sings", "Whispers", "Explores", "Glows"]

    // Function to generate a random title
    func generateRandomTitle() -> String {
        let randomAdjective = adjectives.randomElement() ?? ""
        let randomNoun = nouns.randomElement() ?? ""
        let randomVerb = verbs.randomElement() ?? ""

        return "\(randomAdjective) \(randomNoun) \(randomVerb)"
    }


    // Get the current year
    let currentYear = Calendar.current.component(.year, from: Date())

  return [ 
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),
           Book(title: generateRandomTitle(), author: generateRandomName(), publishedYear: Int(arc4random_uniform(UInt32(30))) + (currentYear - 30)),


  ]
}

}
