//
//  AddNewBookView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 20/09/2023.
//

import SwiftUI

struct AddNewBookView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var author : String = ""
    @State private var publishedYear: Int?

    @State private var selectedGenres = Set<Genre>()

    private var isValid: Bool {
         !title.isEmpty && !author.isEmpty && publishedYear != nil
     }


    var body: some View {

        NavigationStack{
            VStack(alignment: .leading)  {
                Text("Book title:")
                TextField("Enter title",text: $title)
                    .textFieldStyle(.roundedBorder)
                Text("Author:")
                TextField("Enter author",text: $author)
                    .textFieldStyle(.roundedBorder)
                Text("Published:")
                TextField("Enter published year",value: $publishedYear,format: .number)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    GenreSelectionView(selectedGenres: $selectedGenres)
                HStack{
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                    Button("Save") {
                        guard let publishedYear else { return }
                        let book = Book(title:title, author: author, publishedYear: publishedYear)

                        book.genres = Array(selectedGenres)
                        selectedGenres.forEach{ genre in
                            genre.books.append(book)
                            context.insert(genre)
                        }
                        context.insert(book)
                        do {
                            try context.save()
                        } catch {
                            print (error.localizedDescription)
                        }
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .disabled(!isValid)
                }
                Spacer()
            }
           .padding()
//            .navigationTitle("Add new book")
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AddNewBookView().preferredColorScheme(.dark)
}
