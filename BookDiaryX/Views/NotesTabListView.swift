//
//  NotesTabListView.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 10/11/2023.
//

import SwiftUI
import SwiftData

struct NotesTabListView: View {

    @Query(sort: \Note.title) private var notes: [Note]
    @Environment(\.modelContext) private var context

    var body: some View {
            List {
                ForEach(notes) { note in
                    if let book = note.book {
                        NavigationLink(value: NavigationRoute.book(book)) {
                            VStack {
                                Text(note.title)
                                    .bold()
                                Text(note.message)
                            }
                        }
                    } else {
                        VStack {
                            Text(note.title)
                                .bold()
                            Text(note.message)
                        }
                    }
                }
                .onDelete(perform: deleteNote(indexSet:))
            }
}

    private func deleteNote(indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = notes[index]
            context.delete(note)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NotesTabListView()
        .modelContainer(for: [Book.self, Genre.self, Note.self])
}
