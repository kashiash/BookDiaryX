//
//  BookListView.swift
//  BookDiary
//
//  Created by Jacek Kosinski U on 20/09/2023.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query var books: [Book]
    @State private var presentAddNew = false

    var body: some View {
        NavigationStack{
            List{
                ForEach(books) { book in
                    BookCellView(book: book)
                }
                .onDelete(perform: delete(indexSet:))
            }
            .navigationTitle("Lista książek")
            .toolbar {
                ToolbarItem() {
                    Button("",systemImage: "wand.and.stars.inverse"){
                      //  context.insert(Book.generateRandomBook())
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {

                    
                    Button{
                        presentAddNew.toggle()
                    } label: {
                        Image(systemName: "doc.badge.plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $presentAddNew, content: {
                        AddNewBookView()
                    })
                }
            }
        }
    }

    private func delete(indexSet: IndexSet) {
        indexSet.forEach { index in
            let book = books[index]
            context.delete(book)

            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)

   return BookListView()
        .modelContainer(preview.container)
}
