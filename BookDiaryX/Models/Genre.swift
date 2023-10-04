//
//  Genre.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import Foundation
import SwiftData

@Model
final class Genre {
    var name: String
    var books = [Book]()

    init(name: String) {
        self.name = name
    }
}
