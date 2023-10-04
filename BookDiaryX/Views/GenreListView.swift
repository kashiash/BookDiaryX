//
//  GenreListView.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import SwiftUI
import SwiftData

struct GenreListView: View {

    @Query(sort: \Genre.name) private var genres: [Genre]
    @State private var presentAddNew: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    Text(genre.name)
                }
            }
            .navigationTitle("Gatunki Literackie")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        presentAddNew.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $presentAddNew, content: {
                        AddNewGenre()
                            .presentationDetents([.fraction(0.3)])
                            .interactiveDismissDisabled()
                    })
                }
            }
        }

    }
}

#Preview {
    GenreListView()
        .modelContainer(for: [Book.self, Genre.self, Note.self])
}
