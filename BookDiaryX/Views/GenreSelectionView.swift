//
//  GenreSelectionView.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 10/10/2023.
//

import SwiftUI
import SwiftData

struct GenreSelectionView: View {
    @Query(sort: \Genre.name) private var genres: [Genre]
    @Binding var selectedGenres: Set<Genre>

    var body: some View {
        List {
            Section("Gatunki literackie") {
                ForEach(genres) { genre in
                    HStack{
                        Text(genre.name)
                        Spacer()
                        Image(systemName: selectedGenres.contains(genre) ? "checkmark.circle.fill" : "circle.dashed")
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if !selectedGenres.contains(genre) {
                            selectedGenres.insert(genre)
                        } else {
                            selectedGenres.remove(genre)
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

//#Preview {
//    var selectedGenres = Set<Genre>()
//    GenreSelectionView(selectedGenres: $selectedGenres)
//        .modelContainer(for: [Book.self, Genre.self, Note.self])
//
//}
