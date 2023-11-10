//
//  GenreDetailView.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 14/10/2023.
//

import SwiftUI

struct GenreDetailView: View {
    let genre: Genre
    var body: some View {
        VStack {
            Group {
                if genre.books.isEmpty {
                    ContentUnavailableView("Brak ksiażek", systemImage: "square.stack.3d.up.slash")
                } else {

                        List(genre.books) {book in
                            NavigationLink(value: NavigationRoute.book(book)) {
                                Text(book.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle(genre.name)
        }
    }


//#Preview {
//    GenreDetailView()
//}
