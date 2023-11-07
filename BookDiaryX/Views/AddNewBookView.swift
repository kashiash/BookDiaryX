//
//  AddNewBookView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 20/09/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

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

    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?

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

                Section {
                HStack {
                    PhotosPicker(
                        selection: $selectedCover,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Add Cover", systemImage: "book.closed")
                    }
                    .padding(.vertical)
                    Spacer()

                        if let selectedCoverData,
                           let image = UIImage(data: selectedCoverData) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                                .frame(width: 100, height: 100)


                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }

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

                        if let selectedCoverData {
                            book.cover = selectedCoverData
                        }
                        
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
           .navigationTitle("Add new book")
           .navigationBarTitleDisplayMode(.inline)
           .task(id: selectedCover) {
               if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
                   selectedCoverData = data
               }
           }
        }
        //.ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        AddNewBookView()
            //.preferredColorScheme(.dark)
    }
}
