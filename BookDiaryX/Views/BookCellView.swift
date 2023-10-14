//
//  BookCellView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 20/09/2023.
//

import SwiftUI

struct BookCellView: View {
    let book: Book
    var body: some View {
        NavigationLink (value: book){
            VStack(alignment: .leading){
                Text(book.title)
                    .bold()
                HStack{
                    Text("Author: \(book.author)")
                    Spacer()
                    Text("Published on: \(book.publishedYear.description)")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 20)
            }
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
        }
    }
}

//#Preview {
//    BookCellView(book: Book.generateRandomBook())
//        //.modelContainer(for: [Book.self])
//}