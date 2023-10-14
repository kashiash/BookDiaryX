### Widok do dodawania nowych gatunków `AddNewGenre`

Następnie dodamy widok do tworzenia nowej kategorii gatunkowej. Ten widok będzie prezentowany jako dolny panel (bottom sheet) i będzie zawierać pojedyncze pole tekstowe (TextField), które pozwoli dodać nowy gatunek.

```swift
import SwiftUI
import SwiftData

struct AddNewGenre: View {
    @State private var name: String = ""
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Dodaj nowy gatunek", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .navigationTitle("Dodaj nowy gatunek")
                    .padding(.horizontal)
                
                HStack {
                    Button("Zapisz") {
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
}

#Podgląd {
    AddNewGenre()
}
```

Teraz dodamy punkt uruchomienia dla widoku AddNewGenre. Uruchomimy ten widok z GenreListView, więc dodajmy nowy element paska narzędziowego (ToolBarItem).

```swift
import SwiftUI

struct GenreListView: View {
    @Query(sort: \Genre.name) private var genres: [Genre]
    @State private var isAddNewGenrePresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    Text(genre.name)
                }
            }
            .navigationTitle("Gatunki Literackie")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        presentAddNew.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $presentAddNew, content: {
                        AddNewGenre()
                            .presentationDetents([.fraction(0.3)])
                            .interactiveDismissDisabled()
                    })
                }
            }
        }

    }
}

#Podgląd {
    GenreListView()
}
```

Teraz możemy dodać nowe gatunki, a widok AddNewGenre będzie wyświetlany jako dolny panel po naciśnięciu przycisku "Dodaj" na liście gatunków literackich.

###