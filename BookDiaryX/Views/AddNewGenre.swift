//
//  AddNewGenre.swift
//  BookDiaryX
//
//  Created by Jacek Kosinski U on 04/10/2023.
//

import SwiftUI
import SwiftData

struct AddNewGenre: View {
    @State private var name: String = ""

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack{
            VStack{
                TextField("Dodaj nowy gatunek", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .navigationTitle("Dodaj nowy gatunek")
                    .padding(.horizontal)
            }
            HStack {
                Button("Zapisz"){
                    let genre = Genre(name: name)
                    context.insert(genre)
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)

                Button("Anuluj") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
    }
}

#Preview {
    AddNewGenre()
}
