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
        NavigationLink (value: NavigationRoute.book(book)){
            HStack(alignment: .top) {

                if let cover = book.cover,
                   let uiImage = UIImage(data: cover) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Rectangle())
                        .cornerRadius(5)
                        .frame(height: 100)

                }
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

            }

        }
    }
}

//#Preview {
//    BookCellView(book: Book.generateRandomBook())
//        //.modelContainer(for: [Book.self])
//}
