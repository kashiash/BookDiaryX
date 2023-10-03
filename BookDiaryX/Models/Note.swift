//
//  Note.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import Foundation

import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var message: String
    var book: Book?

    init(title: String, message: String, book: Book? = nil) {
        self.title = title
        self.message = message
        self.book = book
    }
}
