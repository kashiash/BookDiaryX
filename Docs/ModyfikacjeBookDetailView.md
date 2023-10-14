

## Modyfikacje BookDetailView

Mamy możliwość dodawania gatunku do nowej książki, ale co z istniejącymi książkami, które zostały dodane przed tą zmianą? Cóż, dodajmy tę funkcję, aktualizując widok `BookDetailView`.

Zaczniemy od stworzenia właściwości stanu `selectedGenres`, która będzie przechowywać wybrane gatunki.

```swift
import SwiftUI

struct BookDetailView: View {
    ...
    
    @State private var selectedGenres = Set<Genre>()

    init(book: Book) {
        ...
        self._selectedGenres = State(initialValue: Set(book.genres))
    }
    
    var body: some View {
        Form {
            if isEditing {
                Group {
                    TextField("Book title", text: $title)
                    TextField("Book author", text: $author)
                    TextField("Published year", value: $publishedYear, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                    
                    GenreSelectionView(selectedGenres: $selectedGenres)
                        .frame(height: 300)
                }
                .textFieldStyle(.roundedBorder)
                Button("Save") {
                    guard let publishedYear = publishedYear else { return }
                    book.title = title
                    book.author = author
                    book.publishedYear = publishedYear
                    
                    book.genres = []
                    book.genres = Array(selectedGenres)
                    selectedGenres.forEach { genre in
                        if !genre.books.contains(where: { b in
                            b.title == book.title
                        }) {
                            genre.books.append(book)
                        }
                    }
                    ...
                }
            } else {
                Text(book.title)
                Text(book.author)
                Text(book.publishedYear.description)

                if !selectedGenres.isEmpty {
                    HStack {
                        ForEach(Array(selectedGenres), id: \.self) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal)
                                .background(Color.green.opacity(0.3), in: Capsule())
                        }
                    }
                }
            }
            ...
        }
    }
}
```

W powyższym kodzie `init`, `selectedGenres` jest inicjowany jako zbiór gatunków przypisanych do książki. Następnie, w zależności od tego, czy edytujemy książkę, czy nie, wyświetlane są odpowiednie widoki. Jeśli edytujemy książkę, dodajemy `GenreSelectionView` do wyboru gatunków i aktualizujemy gatunki wybrane przez użytkownika w `selectedGenres`. Teraz użytkownik będzie mógł edytować gatunki przypisane do już istniejącej książki.