## GenreDetailView 

Prezentujemy kategorie dla każdej książki, ale byłoby świetnie, gdybyśmy mogli zobaczyć także książki w każdej kategorii. Zacznijmy więc od stworzenia nowego widoku w SwiftUI dla szczegółów kategorii, nazwanego „GenreDetailView”.

Zaimportujmy również SwiftData.
Utwórzmy właściwość `genre: Genre`, która będzie używana do przekazywania wybranej przez użytkownika kategorii, których szczegóły będą wyświetlane w widoku.

```swift
import SwiftUI
import SwiftData

struct GenreDetailView: View {
    let genre: Genre
    
    var body: some View {
        Text("Witaj, DevTechie!")
    }
}
```

Zaktualizujmy również widok `GenreListView`, aby zawierał link nawigacyjny. Będziemy używać tego linku nawigacyjnego do przekazywania wybranej przez użytkownika kategorii, która będzie używana w widoku szczegółów."



Aktualizacja widoku `GenreListView` obejmuje użycie linku nawigacyjnego do przekazania wybranej przez użytkownika kategorii, aby można było jej używać w widoku szczegółów. Oto kod:

```swift
import SwiftUI
import SwiftData

struct GenreListView: View {
    // ...
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(genres) { genre in
                    NavigationLink(destination: GenreDetailView(genre: genre)) {
                        Text(genre.name)
                    }
                }
                .onDelete(perform: deleteGenre(indexSet:))
            }
            // ...
        }
        // ...
    }
}
```

Następnie aktualizujemy widok `GenreDetailView`, aby renderować listę książek należących do wybranej kategorii. Użyjemy widoku `ContentUnavailableView` do wyświetlenia pustego stanu. Do wyrenderowania książek w wybranej kategorii użyjemy widoku `List`, a jako tytuł widoku użyjemy nazwy wybranej kategorii. Oto kod:

```swift
import SwiftUI
import SwiftData

struct GenreDetailView: View {
    let genre: Genre
    
    var body: some View {
        VStack {
            Group {
                if genre.books.isEmpty {
                    ContentUnavailableView(
                        "Brak danych",
                        systemImage: "square.stack.3d.up.slash"
                    )
                } else {
                    List(genre.books) { book in
                        Text(book.title)
                    }
                }
            }
            .navigationTitle(genre.name)
        }
    }
}
```

Po wprowadzeniu tych zmian możesz zbudować i uruchomić aplikację.