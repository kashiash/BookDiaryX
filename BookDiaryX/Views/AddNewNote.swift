//
//  AddNewNote.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 03/10/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNewNote: View {
    let book: Book
    @State private var title: String = ""
    @State private var message: String = ""

    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form{
            TextField("Note title",text: $title)
            TextField("Note", text: $message)
            Section {

                if let selectedPhotoData,
                   let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: 300)
                }

                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {

                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                        .foregroundColor(.accentColor)
                }
                if selectedPhotoData != nil {
                    Button("Remove image", systemImage: "xmark", role: .destructive) {
                        withAnimation{
                            selectedPhoto = nil
                            selectedPhotoData = nil
                        }


                    }
                }


            }
        }
        .navigationTitle("Add new note")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    let note = Note(title: title, message: message)
                    note.book = book
                    context.insert(note)
                    do {
                        try context.save()
                        book.notes.append(note)
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
            }

        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotoData = data
            }
        }
    }
}

//#Preview {
//    AddNewNote()
//}
