//
//  NotesListView.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import SwiftUI
import SwiftData

struct NotesListView: View {
    let book: Book
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            ForEach(book.notes) { note in
                NavigationLink(value: note) {
                    VStack {
                        Text(note.title)
                            .bold()
                        Text(note.message)

                    }
                }
            }
            .onDelete(perform: deleteNote(indexSet:))
        }
        .navigationDestination(for: Note.self, destination: NoteDetailView.init)
    }

    private func deleteNote(indexSet: IndexSet) {
            indexSet.forEach { index in
                let note = book.notes[index]
                context.delete(note)
                book.notes.remove(at: index)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
}

//#Preview {
//    let preview = Preview(Book.self)
//    let book = Book.bookWithNotes;
//    NotesListView(book: book)
//        .modelContainer(preview.container)
//}
