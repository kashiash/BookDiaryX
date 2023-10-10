//
//  NoteDetailView.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 05/10/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct NoteDetailView: View {
    @Bindable var  note: Note
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedPhotoData: Data?

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form{
            Group {
                TextField("Note title",text: $note.title)
                TextField("Note", text: $note.message)
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
        }
        .navigationTitle("Edit note")

        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotoData = data

            }
        }
    }
}

#Preview {

    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Note(title: "Bardzo trudny temat", message: "Lorem ipsum \r\n terefere \r\n")

        return NoteDetailView(note: example)
            .modelContainer(container)
    } catch {
        fatalError("Coś się zjebsuło")
    }

}
