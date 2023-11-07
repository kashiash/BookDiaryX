//
//  BookDetailView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 25/09/2023.
//
import SwiftData
import SwiftUI
import PhotosUI

struct BookDetailView: View {
    var book: Book

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var isEditing = false
    @State private var showAddNewNote = false

    @State private var title: String = ""
    @State private var author: String = ""
    @State private var publishedYear: Int? = nil

    @State private var selectedGenres = Set<Genre>()

    @State private var selectedCover: PhotosPickerItem?
    @State private var selectedCoverData: Data?

    init(book: Book) {
        self.book = book
        self._title = State.init(initialValue: book.title)
        self._author = State.init(initialValue: book.author)
        self._publishedYear = State.init(initialValue: book.publishedYear)
        self._selectedGenres = State(initialValue: Set(book.genres))
    }

    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year",
                              value: $publishedYear,
                              formatter: NumberFormatter())
                    .keyboardType(.numberPad)

                    HStack {
                        PhotosPicker(
                            selection: $selectedCover,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            Label(book.cover == nil ? "Add Cover" : "Update Cover", systemImage: "book.closed")
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


                        } else if let cover = book.cover, let image = UIImage(data: cover) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 5))
                                .frame(height: 100)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }

                    GenreSelectionView(selectedGenres: $selectedGenres)
                        .frame(height: 300)
                }
                .textFieldStyle(.roundedBorder)

                Button("Save") {
                    guard let publishedYear = publishedYear else { return }
                    book.title = title
                    book.author = author
                    book.publishedYear = publishedYear

                    if let selectedCoverData {
                        book.cover = selectedCoverData
                    }

                    book.genres = []
                    book.genres = Array(selectedGenres)
                    selectedGenres.forEach { genre in
                        if !genre.books.contains(where: { b in
                            b.title == book.title
                        }) {
                            genre.books.append(book)
                        }
                    }

                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }

                    dismiss()
                }
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)

                if !book.genres.isEmpty {
                    HStack {
                        ForEach(book.genres) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal)
                                .background(Color.green.opacity(0.3), in: Capsule())
                        }
                    }
                }

                if let cover = book.cover, let image = UIImage(data: cover) {
                    HStack {
                        Text("Book Cover")
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Rectangle())
                            .cornerRadius(5)
                            .frame(height: 100)
                    }
                }
            }
            Section("Notes") {
                Button("Add new note") {
                    showAddNewNote.toggle()
                }
                .sheet(isPresented: $showAddNewNote, content: {
                    NavigationStack {
                        AddNewNote(book: book)
                    }
                    .presentationDetents([.fraction(0.3)])
                    .interactiveDismissDisabled()
                })
                if book.notes.isEmpty {
                    ContentUnavailableView("No notes", systemImage: "note")
                } else {
                    NotesListView(book: book)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Cancel" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
        .navigationTitle("Book Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedCover) {
            if let data = try? await selectedCover?.loadTransferable(type: Data.self) {
                selectedCoverData = data
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    return NavigationStack {
        BookDetailView(book: Book.sampleBooks[8])
            .modelContainer(preview.container)

    }
}
