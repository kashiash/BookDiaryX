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
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    NavigationLink(destination: GenreDetailView(genre: genre)) {
                        Text(genre.name)
                    }

                }
                .onDelete(perform: deleteGenre)
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
    private func deleteGenre(atOffsets indexSet: IndexSet) {
        indexSet.forEach { index in
            let genreToDelete = genres[index]
            context.delete(genreToDelete)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    GenreListView()
        .modelContainer(for: [Book.self, Genre.self, Note.self])
}
