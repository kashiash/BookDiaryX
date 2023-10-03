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

    var body: some View {
        List {
            ForEach(book.notes) { note in

                VStack {
                    Text(note.title)
                        .bold()
                    Text(note.message)

                }
            }
        }
    }
}

//#Preview {
//    NotesListView()
//}
