//
//  BookDiaryXApp.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import SwiftUI

enum NavigationRoute:Hashable {
    case note(Note)
    case genre(Genre)
    case book(Book)
    case settings
}

@main
struct BookDiaryXApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .navigationDestination(for: NavigationRoute.self) { route in
                switch route {
                case .book(let book): BookDetailView(book: book)
                case .genre(let genre): GenreDetailView(genre: genre)
                case .note(let note): NoteDetailView(note: note)
                case .settings:
                    SettingsView()
                }
            }
        }
        .modelContainer(for: [Book.self])
    }
}
