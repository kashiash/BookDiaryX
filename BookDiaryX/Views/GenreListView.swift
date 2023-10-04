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
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    Text(genre.name)
                }
            }
            .navigationTitle("Gatunki Literackie")
        }
    }
}

#Preview {
    GenreListView()
}
