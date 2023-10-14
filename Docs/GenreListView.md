## GenreListView

Teraz dodamy widok, który pokaże wszystkie gatunki. Użyjemy makra Query do pobrania przechowywanych rekordów dla modelu Genre.

```swift
import SwiftUI
import SwiftData

struct GenreListView: View {
    
    @Query(sort: \Genre.name) private var genres: [Genre]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    Text(genre.name)
                }
            }
            .navigationTitle("Gatunki Literackie")
        }
    }
}

#Podgląd {
    GenreListView()
}
```

Następnie dodamy ten widok do ContentView. Nasza aplikacja będzie wyświetlać książki i gatunki wewnątrz TabView.

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BookListView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Książki")
                }
            GenreListView()
                .tabItem {
                    Image(systemName: "gear.circle")
                    Text("Gatunki")
                }
        }
    }
}

#Podgląd {
    ContentView()
}
```

Zbuduj i uruchom aplikację.





### Usuwanie gatunków literackich

Skoro jesteśmy już w `GenreListView`, dodajmy funkcję usuwania do tego widoku.

Najpierw potrzebujemy dostępu do kontekstu modelu w GenreListView, aby móc wykonać operację usuwania.

```swift
@Environment(\.modelContext) private var context
```

Następnie dodajmy prywatną funkcję, która usunie gatunek z listy.

```swift
private func deleteGenre(atOffsets indexSet: IndexSet) {
    indexSet.forEach { index in
        let genreToDelete = genres[index]
        context.delete(genreToDelete)
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

Teraz wywołajmy tę funkcję przy użyciu modyfikatora `onDelete` na widoku `ForEach`.

```swift
List {
    ForEach(genres, id: \.self) { genre in
        Text(genre.name)
    }
    .onDelete(perform: deleteGenre)
}
```

Pamiętaj, że modyfikator `onDelete` przyjmuje domknięcie (closure) jako argument, które jest wywoływane, gdy użytkownik próbuje usunąć element z listy. W naszym przypadku wywołuje funkcję `deleteGenre`, która usuwa odpowiedni gatunek i zapisuje zmiany do kontekstu modelu.

Teraz możesz zbudować i uruchomić projekt, a użytkownicy będą mogli usuwać gatunki z listy.

